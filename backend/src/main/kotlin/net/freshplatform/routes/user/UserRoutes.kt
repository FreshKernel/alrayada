package net.freshplatform.routes.user

import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.html.*
import io.ktor.server.plugins.ratelimit.*
import io.ktor.server.request.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import kotlinx.html.*
import net.freshplatform.data.user.User
import net.freshplatform.data.user.UserData
import net.freshplatform.data.user.UserDataSource
import net.freshplatform.data.user.UserDeviceNotificationsToken
import net.freshplatform.services.mail.EmailMessage
import net.freshplatform.services.mail.MailSenderService
import net.freshplatform.services.security.hashing.HashingService
import net.freshplatform.services.security.hashing.SaltedHash
import net.freshplatform.services.security.social_authentication.SocialAuthUserData
import net.freshplatform.services.security.social_authentication.SocialAuthentication
import net.freshplatform.services.security.social_authentication.SocialAuthenticationService
import net.freshplatform.services.security.token.JwtService
import net.freshplatform.services.security.verification_token.TokenVerificationService
import net.freshplatform.services.telegram.TelegramBotService
import net.freshplatform.utils.ErrorResponseException
import net.freshplatform.utils.constants.Constants
import net.freshplatform.utils.constants.PatternsConstants
import net.freshplatform.utils.extensions.isPasswordStrong
import net.freshplatform.utils.extensions.isProductionMode
import net.freshplatform.utils.extensions.isValidEmail
import net.freshplatform.utils.extensions.request.*
import net.freshplatform.utils.extensions.webcontent.webContentHeader
import java.time.LocalDateTime

class UserRoutes(
    private val router: Route,
    private val userDataSource: UserDataSource,
    private val hashingService: HashingService,
    private val jwtService: JwtService,
    private val tokenVerificationService: TokenVerificationService,
    private val mailSenderService: MailSenderService,
    private val socialAuthenticationService: SocialAuthenticationService,
    private val telegramBotService: TelegramBotService
) {
    companion object {
        const val SIGN_IN_ROUTE_NAME = "signIn"
        const val SIGN_UP_ROUTE_NAME = "signUp"
    }

    private suspend fun notifyTelegramChatAboutRegister(user: User) {
        val msg = buildString {
            append("A new user has inserted in the database\n")
            append("Lab owner name: <b>${user.data.labOwnerName}</b>\n")
            append("Lab name: <b>${user.data.labName}</b>\n")
            append("Lab owner phone: <b>${user.data.labOwnerPhoneNumber}</b>\n")
            append("Lab phone: <b>${user.data.labPhoneNumber}</b>\n")
        }
        telegramBotService.sendMessage(text = msg)
    }

    /**
     * Apple redirect url for Android
     * */
    fun signInWithAppleWeb() = router.route("/socialLogin/signInWithApple") {
        handle {
            val parameters = call.receiveParameters()
            val params = Parameters.build {
                parameters.forEach { s, strings ->
                    append(s, strings.first())
                }
            }
            // Android
            call.respondRedirect("intent://callback?${params.formUrlEncode()}#Intent;package=${Constants.MobileAppId.ANDROID};scheme=signinwithapple;end")
        }
    }

    fun socialAuthentication() = router.post("/socialLogin") {
        call.protectRouteToAppOnly()
        val socialUserData: SocialAuthUserData
        val socialAuthRequest: SocialAuthentication

        when (call.requireParameter("provider")) {
            SocialAuthentication.Google::class.simpleName -> {
                val googleSocialRequest = call.receiveBodyAs<SocialAuthentication.Google>()
                socialAuthRequest = googleSocialRequest
                socialUserData = socialAuthenticationService.authenticateWith(
                    SocialAuthentication.Google(
                        googleSocialRequest.idToken,
                        googleSocialRequest.signUpUserData,
                        socialAuthRequest.deviceToken
                    )
                ) ?: throw ErrorResponseException(
                    HttpStatusCode.BadRequest, "Token of google account is not valid!", "INVALID_TOKEN"
                )
            }

            SocialAuthentication.Apple::class.simpleName -> {
                val appleSocialRequest = call.receiveBodyAs<SocialAuthentication.Apple>()
                socialAuthRequest = appleSocialRequest
                val identityToken = appleSocialRequest.identityToken
                val userId = appleSocialRequest.userId
                socialUserData = socialAuthenticationService.authenticateWith(
                    SocialAuthentication.Apple(
                        identityToken,
                        userId,
                        appleSocialRequest.signUpUserData,
                        socialAuthRequest.deviceToken
                    )
                ) ?: throw ErrorResponseException(
                    HttpStatusCode.BadRequest, "Token of apple account is not valid!", "INVALID_TOKEN"
                )
            }

            else -> {
                throw ErrorResponseException(HttpStatusCode.BadRequest, "Unsupported provider.", "UNSUPPORTED")
            }
        }

        if (!socialUserData.emailVerified) {
            throw ErrorResponseException(HttpStatusCode.BadRequest, "Email is not verified.", "EMAIL_NOT_VERIFIED")
        }

        var isSignIn = true
        val user = userDataSource.getUserByEmail(socialUserData.email) ?: kotlin.run {
            val signUpUserData = socialAuthRequest.signUpUserData
                ?: throw ErrorResponseException(
                    HttpStatusCode.BadRequest,
                    "There is no matching email account, so please provider sign up data to create the account",
                    "USER_NOT_FOUND"
                )
            isSignIn = false
            val user = User(
                email = socialUserData.email,
                password = "",
                salt = "",
                uuid = User.generateUniqueUUID(userDataSource),
                tokenVerifications = setOf(tokenVerificationService.generate(User.Companion.TokenVerificationData.EmailVerification.NAME)),
                emailVerified = true,
                data = signUpUserData,
                createdAt = LocalDateTime.now(),
                deviceNotificationsToken = socialAuthRequest.deviceToken,
                pictureUrl = socialUserData.pictureUrl
            )
            val success = userDataSource.insertUser(user)
            if (!success) {
                throw ErrorResponseException(
                    HttpStatusCode.InternalServerError, "Error while insert the user to the database", "UNKNOWN_ERROR"
                )
            }
            notifyTelegramChatAboutRegister(user)
            user
        }
        if (isSignIn) {
            userDataSource.updateDeviceTokenById(
                newDeviceToken = socialAuthRequest.deviceToken,
                userId = user.uuid
            )
        }
        val jwtValue = jwtService.generateUserToken(user.stringId())
        call.respond(
            HttpStatusCode.OK,
            AuthSignInResponse(
                token = jwtValue.token,
                expiresIn = jwtValue.expiresIn,
                expiresAt = jwtValue.expiresAt,
                user = user.toResponse(call),
            ),
        )
    }

    fun signUpWithEmailAndPassword() = router.rateLimit(RateLimitName(SIGN_UP_ROUTE_NAME)) {
        post("/${SIGN_UP_ROUTE_NAME}") {
            call.protectRouteToAppOnly()

            val request = call.receiveBodyAs<AuthSignUpRequest>()
            val error = request.validate()
            if (error != null) {
                throw ErrorResponseException(HttpStatusCode.BadRequest, error.first, error.second)
            }

            val isEmailUsed = userDataSource.getUserByEmail(request.email) != null
            if (isEmailUsed) {
                throw ErrorResponseException(
                    HttpStatusCode.Conflict,
                    "Email already in use. Please use a different email or try logging in.",
                    "EMAIL_USED"
                )
            }

            val password = hashingService.generateSaltedHash(request.password)

            val emailVerificationData =
                tokenVerificationService.generate(User.Companion.TokenVerificationData.EmailVerification.NAME)

            val newUser = User(
                email = request.email.lowercase(),
                password = password.hash,
                salt = password.salt,
                uuid = User.generateUniqueUUID(userDataSource),
                tokenVerifications = setOf(emailVerificationData),
                data = request.userData,
                createdAt = LocalDateTime.now(),
                deviceNotificationsToken = request.deviceToken
            )
            val createUserSuccess = userDataSource.insertUser(newUser)
            if (!createUserSuccess) {
                throw ErrorResponseException(
                    HttpStatusCode.InternalServerError,
                    "Sorry, there is error while register the account, please try again later",
                    "UNKNOWN_ERROR"
                )
            }
            val verificationLink =
                call.generateEmailVerificationLink(
                    email = newUser.email,
                    token = emailVerificationData.token
                )
            val sendEmailSuccess = mailSenderService.sendEmail(
                EmailMessage(
                    to = newUser.email,
                    subject = "Email account verification link",
                    body = "Hi, you have sign up on our platform,\n" +
                            " to confirm your email, we need you to open this link\n" +
                            "$verificationLink\n\nif you didn't do that," +
                            " please ignore this message"
                )
            )
            if (!isProductionMode()) {
                println("Here is your verification link: $verificationLink")
            }
            if (!sendEmailSuccess) {
                throw ErrorResponseException(
                    HttpStatusCode.InternalServerError,
                    "An error occurred while sending the email verification link, please try again by sign in or contact us",
                    "UNKNOWN_ERROR"
                )
            }
            notifyTelegramChatAboutRegister(newUser)

            call.respondJsonText(
                HttpStatusCode.Created,
                "We have sent you email verification link to your email to confirm it"
            )
        }
    }

    /*
    * If you want to change the route path
    * Remember to change it from generateEmailVerificationLink() too
    * */
    fun verifyEmailAccount() = router.get("/verifyEmailAccount") {
        val email = call.requireParameter("email")
        var message = "Email has successfully verified."
        var status = HttpStatusCode.OK
        if (!email.isValidEmail()) {
            message = "Please enter a" + " valid email address."
            status = HttpStatusCode.BadRequest
        }
        val enteredVerifyToken = call.requireParameter("token")
        val user = userDataSource.getUserByEmail(email)
        val emailTokenVerification = user?.let { User.Companion.TokenVerificationData.EmailVerification.find(it) }

        if (user == null) {
            status = HttpStatusCode.NotFound
            message = "Sorry, we couldn't" + " find this account."
        } else {
            if (user.emailVerified) {
                message = "Account is already verified."
                status = HttpStatusCode.BadRequest
            } else if (emailTokenVerification == null) {
                message = "Internal server error, email verification data is null, please contact us"
                status = HttpStatusCode.InternalServerError
            } else if (emailTokenVerification.hasTokenExpired()) {
                message = "Token has been expired."
                status = HttpStatusCode.Gone
            } else if (emailTokenVerification.token != enteredVerifyToken) {
                message = "Token is not valid."
                status = HttpStatusCode.BadRequest
            } else if (!userDataSource.verifyEmail(user.email)) {
                message = "Error while " +
                        "verify the account, please try again later."
                status = HttpStatusCode.InternalServerError
            }
        }

        call.respondHtml(
            status = status
        ) {
            webContentHeader("Verify email")
            body {
                div(
                    classes = "center-screen",
                ) {
                    div("card") {
                        +message
                    }
                }
            }
        }
    }

    fun signInWithEmailAndPassword() = router.rateLimit(RateLimitName(SIGN_IN_ROUTE_NAME)) {
        post("/$SIGN_IN_ROUTE_NAME") {
            call.protectRouteToAppOnly()
            val request = call.receiveBodyAs<AuthSignInRequest>()
            val error = request.validate()
            if (error != null) {
                throw ErrorResponseException(
                    status = HttpStatusCode.BadRequest,
                    message = error.first,
                    code = error.second,
                )
            }

            // Required for security, because social login set the password as empty
            if (request.password.isBlank()) {
                throw ErrorResponseException(
                    HttpStatusCode.BadRequest,
                    "Please enter your password",
                    "PASSWORD_EMPTY",
                )
            }
            val user = userDataSource.getUserByEmail(request.email) ?: throw ErrorResponseException(
                HttpStatusCode.NotFound,
                "Email not found. Please check your email address and try again.",
                "USER_NOT_FOUND",
            )
            val isValidPassword = hashingService.verify(
                request.password,
                saltedHash = SaltedHash(
                    hash = user.password,
                    salt = user.salt
                )
            )
            if (!isValidPassword) {
                throw ErrorResponseException(
                    HttpStatusCode.Unauthorized,
                    "Incorrect password.",
                    "INVALID_CREDENTIALS",
                )
            }
            if (!user.emailVerified) {
                val emailTokenVerification = User.Companion.TokenVerificationData.EmailVerification.find(user)
                    ?: throw ErrorResponseException(
                        HttpStatusCode.InternalServerError,
                        "This was not supposed to happen",
                        "UNKNOWN_ERROR"
                    )
                if (!emailTokenVerification.hasTokenExpired()) {
                    throw ErrorResponseException(
                        HttpStatusCode.Gone,
                        "Verification link is already sent," +
                                " it will expire after ${emailTokenVerification.minutesToExpire()} minutes.",
                        "VERIFICATION_LINK_ALREADY_SENT",
                        mapOf("minutesToExpire" to emailTokenVerification.minutesToExpire().toString())
                    )

                }
                val emailVerificationData =
                    tokenVerificationService.generate(User.Companion.TokenVerificationData.EmailVerification.NAME)
                val updateSuccess = userDataSource.updateEmailVerificationData(
                    request.email,
                    emailVerificationData
                )
                if (!updateSuccess) {
                    throw ErrorResponseException(
                        HttpStatusCode.InternalServerError, "Your email" +
                                " account is not verified" +
                                " We tried to update email verification link," +
                                " but we have some error," +
                                " Please try again later or contact us.",
                        "UNKNOWN_ERROR"
                    )
                }
                val verificationLink = call.generateEmailVerificationLink(
                    email = user.email,
                    token = emailTokenVerification.token
                )
                val sendEmailSuccess = mailSenderService.sendEmail(
                    EmailMessage(
                        to = user.email,
                        subject = "Email account verification link",
                        body = "Hi, you have sign up on our platform,\n" +
                                " to confirm your email, we need you to open this link\n" +
                                verificationLink + "\n\nif you didn't do that, please " +
                                "ignore this message"
                    )
                )
                if (!sendEmailSuccess) {
                    throw ErrorResponseException(
                        HttpStatusCode.InternalServerError, "Your email" +
                                " account is not verified" +
                                " We tried to send you email verification link," +
                                " but we have some error," +
                                " Please try again later or contact us.",
                        "UNKNOWN_ERROR"
                    )
                }
                throw ErrorResponseException(
                    HttpStatusCode.TemporaryRedirect, "Your email account is not" +
                            " verified" +
                            ", we have sent you" +
                            " the link to confirm that email belong to you," +
                            " please open it.",
                    "EMAIL_VERIFICATION"
                )
            }
            request.deviceToken?.let { deviceToken ->
                userDataSource.updateDeviceTokenById(deviceToken, user.stringId())
            }
            val jwtValue = jwtService.generateUserToken(user.stringId())
            call.respond(
                HttpStatusCode.OK,
                AuthSignInResponse(
                    token = jwtValue.token,
                    expiresIn = jwtValue.expiresIn,
                    expiresAt = jwtValue.expiresAt,
                    user = user.toResponse(call)
                ),
            )
        }
    }

    fun forgotPassword() = router.post("/forgotPassword") {
        call.protectRouteToAppOnly()
        val email = call.requireParameter("email")
        val user = userDataSource.getUserByEmail(email) ?: throw ErrorResponseException(
            HttpStatusCode.NotFound,
            "Email not found. Please check your email address and try again.",
            "EMAIL_NOT_FOUND"
        )
        val forgotPasswordData = User.Companion.TokenVerificationData.ForgotPassword.find(user)
        if (forgotPasswordData != null && !forgotPasswordData.hasTokenExpired()) {
            throw ErrorResponseException(
                HttpStatusCode.Conflict,
                "We already have sent you link " +
                        "to reset your password, and it will expire" +
                        " after ${forgotPasswordData.minutesToExpire()} minutes",
                "LINK_ALREADY_SENT",
                mapOf("minutesToExpire" to forgotPasswordData.minutesToExpire().toString())
            )
        }
        val forgotPasswordVerification =
            tokenVerificationService.generate(User.Companion.TokenVerificationData.ForgotPassword.NAME)
        val success = userDataSource.updateForgotPasswordData(
            email = email,
            tokenVerification = forgotPasswordVerification
        )
        if (!success) {
            throw ErrorResponseException(
                HttpStatusCode.InternalServerError,
                "Error while updating forgot password link, Please try again later or contact us.",
                "UNKNOWN_ERROR",
            )
        }
        val resetPasswordUrl = call.generateResetPasswordFormVerificationLink(
            email = user.email,
            token = forgotPasswordVerification.token,
        )
        val sendEmailSuccess = mailSenderService.sendEmail(
            EmailMessage(
                to = user.email,
                subject = "Forgot password link",
                body = "You did request reset your password, if it was you" +
                        "\nplease open the following link\n${resetPasswordUrl}\n\n" +
                        "if you didn't request that, please ignore this message"
            )
        )
        if (!sendEmailSuccess) {
            call.respondJsonText(
                HttpStatusCode.InternalServerError,
                "Error while " +
                        "send forgot password link, Please try again later or" +
                        " contact us."
            )
        }
        call.respondText(
            "We have sent you reset password link" +
                    " to your email inbox.",
            status = HttpStatusCode.OK,
        )
    }

    /*
   * If you want to change the route path
   * Remember to change it from generateResetPasswordFormVerificationLink() too
   * */
    fun resetPasswordForm() = router.get("/resetPasswordForm") {
        val email = call.requireParameter("email")
        val token = call.requireParameter("token")
        call.respondHtml {
            webContentHeader("Reset password")
            body {
                div(
                    classes = "center-screen",
                ) {
                    form(
                        action = "/api/authentication/resetPassword",
                        method = FormMethod.get,
                        classes = "card",
                    ) {
                        name = "resetPasswordForm"
                        hiddenInput {
                            name = "token"
                            value = token
                            required = true
                        }
                        hiddenInput {
                            name = "email"
                            value = email
                            required = true
                        }
                        label {
                            this.htmlFor = "newPassword"
                            b { +"New Password" }
                        }
                        passwordInput {
                            name = "newPassword"
                            placeholder = "Enter password"
                            required = true
                            pattern = PatternsConstants.PASSWORD
                        }
                        div {
                            style = "padding-top: 10px"
                        }
                        submitInput { value = "Send" }
//                    buttonInput {
//                        type = InputType.submit
//                        value = "Send"
//                    }
                    }
                }
            }
        }
    }

    fun resetPassword() = router.get("/resetPassword") {
        val email = call.requireParameter("email")
        val token = call.requireParameter("token")
        val newPasswordPlainText = call.requireParameter("newPassword")

        if (!email.isValidEmail()) {
            throw ErrorResponseException(
                HttpStatusCode.BadRequest, "Please enter a valid email address.", "INVALID_PASSWORD"
            )
        }
        val user = userDataSource.getUserByEmail(email) ?: throw ErrorResponseException(
            HttpStatusCode.NotFound,
            "Email not found. Please check your email address and try again.",
            "USER_NOT_FOUND"
        )
        val forgotPasswordData = User.Companion.TokenVerificationData.ForgotPassword.find(user)
            ?: throw ErrorResponseException(
                HttpStatusCode.BadRequest, "You didn't request reset password link.", "NO_REQUEST"
            )
        if (forgotPasswordData.hasTokenExpired()) {
            throw ErrorResponseException(
                HttpStatusCode.Gone, "Request has been expired.", "TOKEN_EXPIRED"
            )
        }
        if (token != forgotPasswordData.token) {
            throw ErrorResponseException(
                HttpStatusCode.Unauthorized, "Token is not correct.", "INCORRECT_TOKEN"
            )
        }
        val newPassword = hashingService.generateSaltedHash(newPasswordPlainText)
        val updateProcessSuccess = userDataSource.updateUserPasswordById(
            newPassword = newPassword.hash,
            salt = newPassword.salt,
            userId = user.uuid
        )
        if (!updateProcessSuccess) {
            throw ErrorResponseException(
                HttpStatusCode.InternalServerError, "Error while updating the password.", "UNKNOWN_ERROR"
            )
        }
        call.respondJsonText(HttpStatusCode.OK, "Password has been successfully updated")
    }

    fun getUserData() = router.authenticate {
        get("/user") {
            call.respond(HttpStatusCode.OK, call.requireAuthenticatedUser().toResponse(call))
        }
    }

    fun updateUserData() = router.authenticate {
        put("/userData") {
            val userData = call.receiveBodyAs<UserData>()
            val error = userData.validate()
            if (error != null) {
                throw ErrorResponseException(HttpStatusCode.BadRequest, error.first, error.second)
            }
            val user = call.requireAuthenticatedUser()
            val updateSuccess = userDataSource.updateUserDataById(
                userData = userData,
                userUUID = user.uuid
            )
            if (!updateSuccess) {
                throw ErrorResponseException(
                    HttpStatusCode.InternalServerError, "Error while" +
                            " update the user data.", "UNKNOWN_ERROR"
                )
            }

            call.respondJsonText(HttpStatusCode.OK, "User data has been updated.")
        }
    }

    fun updateDeviceToken() = router.authenticate {
        patch("/updateDeviceToken") {
            val deviceToken = call.receiveBodyAs<UserDeviceNotificationsToken>()
            val valid = deviceToken.validate()
            if (!valid) {
                call.respondJsonText(
                    HttpStatusCode.BadRequest,
                    "The string body which is deviceToken should not be empty."
                )
                return@patch
            }
            val currentUser = call.requireAuthenticatedUser()
            val updateSuccess = userDataSource.updateDeviceTokenById(
                deviceToken,
                currentUser.uuid
            )
            if (!updateSuccess) {
                call.respondJsonText(HttpStatusCode.InternalServerError, "Error while update the device token.")
                return@patch
            }
            call.respondJsonText(HttpStatusCode.OK, "deviceToken has been updated")
        }
    }

    fun updatePassword() = router.authenticate {
        patch("/updatePassword") {
            val currentPassword = call.requireParameter("currentPassword")
            val newPassword = call.requireParameter("newPassword")
            val user = call.requireAuthenticatedUser()

            if (currentPassword == newPassword) {
                throw ErrorResponseException(
                    HttpStatusCode.BadRequest, "Please choose a new password.",
                    "SAME_PASSWORD"
                )
            }
            if (!newPassword.isPasswordStrong()) {
                call.respondJsonText(HttpStatusCode.BadRequest, "Please enter a strong password")
                throw ErrorResponseException(
                    HttpStatusCode.BadRequest, "Please enter a strong password",
                    "WEAK_PASSWORD"
                )
            }
            val currentPasswordValid = hashingService.verify(
                value = currentPassword,
                saltedHash = SaltedHash(
                    hash = user.password,
                    salt = user.salt,
                )
            )
            if (!currentPasswordValid) {
                throw ErrorResponseException(
                    HttpStatusCode.Unauthorized,
                    "Current password is invalid password.",
                    "INVALID_PASSWORD"
                )
            }
            val password = hashingService.generateSaltedHash(newPassword)
            val updateSuccess = userDataSource.updateUserPasswordById(
                newPassword = password.hash,
                salt = password.salt,
                userId = user.uuid
            )
            if (!updateSuccess) {
                throw ErrorResponseException(
                    HttpStatusCode.InternalServerError,
                    "Error while update the password.",
                    "UPDATE_ERROR"
                )
            }
            call.respondJsonText(HttpStatusCode.OK, "Password has been updated.")
        }
    }

    fun deleteSelfAccount() = router.authenticate {
        delete("/deleteAccount") {
            val user = call.requireAuthenticatedUser()
            val deleteSuccess = userDataSource.deleteUserById(user.stringId())
            if (!deleteSuccess) {
                throw ErrorResponseException(
                    HttpStatusCode.InternalServerError, "Error while delete the user", "DELETE_ERROR"
                )
            }
            call.respondJsonText(HttpStatusCode.OK, "User has been successfully deleted!")
        }
    }
}