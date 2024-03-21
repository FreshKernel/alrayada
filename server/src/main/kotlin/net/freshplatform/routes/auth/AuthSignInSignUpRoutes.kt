package net.freshplatform.routes.auth

import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.request.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import io.ktor.server.util.*
import kotlinx.datetime.Clock
import net.freshplatform.data.user.*
import net.freshplatform.services.email_sender.EmailMessage
import net.freshplatform.services.email_sender.EmailSenderService
import net.freshplatform.services.security.hashing.BcryptHashingService
import net.freshplatform.services.security.jwt.JwtService
import net.freshplatform.services.security.social_login.SocialLogin
import net.freshplatform.services.security.social_login.SocialLoginRequest
import net.freshplatform.services.security.social_login.SocialLoginService
import net.freshplatform.services.security.social_login.SocialLoginUserData
import net.freshplatform.services.security.token_verification.TokenVerificationService
import net.freshplatform.services.telegram_bot.TelegramBotService
import net.freshplatform.utils.ErrorResponseException
import net.freshplatform.utils.extensions.baseUrl
import org.koin.ktor.ext.inject

private suspend fun notifyAdminsUserRegistration(user: User, telegramBotService: TelegramBotService) {
    val message = buildString {
        append("A new user has inserted in the database\n")
        append("Lab owner name: <b>${user.info.labOwnerName}</b>\n")
        append("Lab name: <b>${user.info.labName}</b>\n")
        append("Lab owner phone: <b>${user.info.labOwnerPhoneNumber}</b>\n")
        append("Lab phone: <b>${user.info.labPhoneNumber}</b>\n")
        append("Email address: <b>${user.email}</b>\n")
    }
    telegramBotService.sendMessage(message)
}

fun Route.signUpWithEmailAndPassword() {
    val userDataSource by inject<UserDataSource>()
    val bcryptHashingService by inject<BcryptHashingService>()
    val tokenVerificationService by inject<TokenVerificationService>()
    val emailSenderService by inject<EmailSenderService>()
    val telegramBotService by inject<TelegramBotService>()
    val jwtService by inject<JwtService>()

    post("/signUp") {
        val request = call.receive<AuthSignUpRequest>()

        val error = request.validate()
        if (error != null) {
            throw ErrorResponseException(HttpStatusCode.BadRequest, error.first, error.second)
        }

        val findUserByEmail = userDataSource.findUserByEmail(request.email).getOrElse {
            throw ErrorResponseException(
                HttpStatusCode.InternalServerError,
                "Unknown error while trying to find this user with this email",
                "UNKNOWN_ERROR"
            )
        }
        val isEmailUsed = findUserByEmail != null
        if (isEmailUsed) {
            throw ErrorResponseException(
                HttpStatusCode.Conflict,
                "Email already in use. Please use a different email or try logging in.",
                "EMAIL_USED"
            )
        }

        val hashedPassword = bcryptHashingService.generatedSaltedHash(request.password)

        val user = User(
            email = request.email.lowercase(),
            password = hashedPassword,
            isAccountActivated = false,
            isEmailVerified = false,
            role = UserRole.User,
            info = request.userInfo,
            deviceNotificationsToken = request.deviceNotificationsToken,
            pictureUrl = null,
            emailVerification = tokenVerificationService.generate(AuthUtils.EMAIL_VERIFICATION_TOKEN_EXPIRATION),
            resetPasswordVerification = null,
            createdAt = Clock.System.now(),
            updatedAt = Clock.System.now(),
        )

        val createUserSuccess = userDataSource.insertUser(user)
        if (!createUserSuccess) {
            throw ErrorResponseException(
                HttpStatusCode.InternalServerError,
                "Sorry, there is error while register the account, please try again later",
                "UNKNOWN_ERROR"
            )
        }

        val verificationLink =
            AuthUtils.createEmailVerificationLink(
                baseUrl = call.request.baseUrl(),
                email = user.email,
                emailVerificationToken = user.emailVerification?.token
                    ?: throw IllegalStateException(
                        "The emailVerification is not " +
                                "supposed to be null, make sure you set it when creating the user"
                    )
            )

        val isSendEmailSuccess = emailSenderService.sendEmail(
            EmailMessage(
                to = user.email,
                subject = "Email account verification link",
                body = "Hello, you've registered on our platform.\n" +
                        "To verify your email, kindly click on the following link:\n" +
                        "$verificationLink\n\nIf you haven't initiated this action," +
                        " please disregard this message."
            )
        )
        if (!isSendEmailSuccess) {
            throw ErrorResponseException(
                HttpStatusCode.InternalServerError,
                "An error occurred while sending the email verification link, please try again by sign in or contact us",
                "UNKNOWN_ERROR"
            )
        }

        val accessToken = jwtService.generateAccessToken(user.id.toString(), AuthUtils.USER_ACCESS_TOKEN_EXPIRES_IN)

        call.respond(
            HttpStatusCode.Created,
            AuthenticatedUserResponse(
                accessToken = accessToken.token,
                refreshToken = "",
                user = user.toResponse()
            )
        )

        notifyAdminsUserRegistration(
            user, telegramBotService
        )
    }
}

fun Route.signInWithEmailAndPassword() {
    val userDataSource by inject<UserDataSource>()
    val bcryptHashingService by inject<BcryptHashingService>()
    val jwtService by inject<JwtService>()

    post("/signIn") {
        val request = call.receive<AuthSignInRequest>()
        val error = request.validate()
        if (error != null) {
            throw ErrorResponseException(
                status = HttpStatusCode.BadRequest,
                message = error.first,
                code = error.second,
            )
        }

        val user = userDataSource.findUserByEmail(request.email).getOrElse {
            throw ErrorResponseException(
                HttpStatusCode.InternalServerError,
                "Unknown error while trying to find this user with this email",
                "UNKNOWN_ERROR"
            )
        } ?: throw ErrorResponseException(
            HttpStatusCode.Unauthorized,
            "Incorrect email or password",
            "INVALID_CREDENTIALS"
        ) /*throw ErrorResponseException(
            HttpStatusCode.NotFound,
            "Email not found. Please check your email address and try again.",
            "EMAIL_NOT_FOUND",
        )*/

        val isValidPassword = bcryptHashingService.verify(request.password, user.password)
        if (!isValidPassword) {
            throw ErrorResponseException(
                HttpStatusCode.Unauthorized,
                "Incorrect email or password.",
                "INVALID_CREDENTIALS"
            ) /*throw ErrorResponseException(
                HttpStatusCode.Unauthorized,
                "Incorrect password.",
                "WRONG_PASSWORD"
            )*/
        }

        request.deviceNotificationsToken?.let {
            userDataSource.updateDeviceNotificationsTokenById(
                deviceNotificationsToken = it,
                userId = user.id.toString()
            )
        }

        val accessToken =
            jwtService.generateAccessToken(userId = user.id.toString(), AuthUtils.USER_ACCESS_TOKEN_EXPIRES_IN)

        call.respond(
            AuthenticatedUserResponse(
                accessToken = accessToken.token,
                refreshToken = "",
                user = user.toResponse()
            )
        )
    }
}

fun Route.socialLogin() {
    val socialLoginService by inject<SocialLoginService>()
    val userDataSource by inject<UserDataSource>()
    val jwtService by inject<JwtService>()
    val telegramBotService by inject<TelegramBotService>()

    post("/socialLogin") {
        val provider: String by call.request.queryParameters
        val socialUserData: SocialLoginUserData

        // userInfo is null for sign in, not null for sign up
        val (userInfo, deviceNotificationsToken) = when (provider) {
            SocialLogin.Google::class.simpleName -> {
                val googleSocialRequest = call.receive<SocialLoginRequest<SocialLogin.Google>>()
                socialUserData = socialLoginService.authenticateWith(googleSocialRequest.socialLogin).getOrElse {
                    throw ErrorResponseException(
                        HttpStatusCode.InternalServerError,
                        "Unknown error while validating the social login info for Google",
                        "UNKNOWN_ERROR"
                    )
                } ?: throw ErrorResponseException(
                    HttpStatusCode.Unauthorized, "Invalid social login info for Google", "INVALID_SOCIAL_INFO",
                )
                Pair(googleSocialRequest.userInfo, googleSocialRequest.deviceNotificationsToken)
            }

            SocialLogin.Apple::class.simpleName -> {
                val appleSocialRequest = call.receive<SocialLoginRequest<SocialLogin.Apple>>()
                socialUserData = socialLoginService.authenticateWith(appleSocialRequest.socialLogin).getOrElse {
                    throw ErrorResponseException(
                        HttpStatusCode.InternalServerError,
                        "Unknown error while validating the social login info for Apple",
                        "UNKNOWN_ERROR"
                    )
                } ?: throw ErrorResponseException(
                    HttpStatusCode.Unauthorized, "Invalid social login info for Apple", "INVALID_SOCIAL_INFO",
                )
                Pair(appleSocialRequest.userInfo, appleSocialRequest.deviceNotificationsToken)
            }

            else -> throw ErrorResponseException(
                HttpStatusCode.BadRequest, "Unsupported provider: $provider", "UNSUPPORTED"
            )
        }

        var user = userDataSource.findUserByEmail(socialUserData.email).getOrElse {
            throw ErrorResponseException(
                HttpStatusCode.InternalServerError,
                "Unknown error while trying to find this user with this email",
                "UNKNOWN_ERROR"
            )
        } ?: kotlin.run {
            val signUpUserInfo = userInfo ?: throw ErrorResponseException(
                HttpStatusCode.UnprocessableEntity,
                "There is no matching email account, to create an account you must provide the user info.",
                "SOCIAL_MISSING_SIGNUP_DATA"
            )
            val newUser = User(
                email = socialUserData.email.lowercase(),
                password = "", // No password
                isAccountActivated = false,
                isEmailVerified = socialUserData.isEmailVerified,
                role = UserRole.User,
                info = signUpUserInfo,
                deviceNotificationsToken = deviceNotificationsToken,
                pictureUrl = socialUserData.pictureUrl,
                emailVerification = null,
                resetPasswordVerification = null,
                createdAt = Clock.System.now(),
                updatedAt = Clock.System.now(),
            )
            val isCreateSuccess = userDataSource.insertUser(newUser)
            if (!isCreateSuccess) {
                throw ErrorResponseException(
                    HttpStatusCode.InternalServerError,
                    "Unknown error while trying to insert the user in the database.",
                    "UNKNOWN_ERROR"
                )
            }
            notifyAdminsUserRegistration(newUser, telegramBotService)
            newUser
        }

        val isSignIn = userInfo == null
        if (isSignIn) {
            userDataSource.updateDeviceNotificationsTokenById(
                user.id.toString(),
                deviceNotificationsToken
            )
            // When the user is not verified in the database but verified in social login then we will verify him/her
            if (!user.isEmailVerified && socialUserData.isEmailVerified) {
                val isVerifyEmailSuccess = userDataSource.verifyEmail(user.email)
                if (!isVerifyEmailSuccess) throw ErrorResponseException(
                    HttpStatusCode.InternalServerError,
                    "Unknown error while verify the user email in the database.",
                    "UNKNOWN_ERROR"
                )
                user = user.copy(isEmailVerified = true)
            }
        }

        val accessToken =
            jwtService.generateAccessToken(user.id.toString(), AuthUtils.USER_ACCESS_TOKEN_EXPIRES_IN).token

        call.respond(
            if (isSignIn) HttpStatusCode.OK else HttpStatusCode.Created,
            AuthenticatedUserResponse(
                accessToken = accessToken,
                refreshToken = "",
                user = user.toResponse(),
            )
        )

    }
}