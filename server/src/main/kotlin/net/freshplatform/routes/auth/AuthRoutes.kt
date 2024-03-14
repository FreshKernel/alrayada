package net.freshplatform.routes.auth

import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
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
import net.freshplatform.services.security.token_verification.TokenVerificationService
import net.freshplatform.services.telegram_bot.TelegramBotService
import net.freshplatform.utils.ErrorResponseException
import net.freshplatform.utils.extensions.baseUrl
import net.freshplatform.utils.extensions.isValidEmailAddress
import net.freshplatform.utils.extensions.isValidPassword
import net.freshplatform.utils.extensions.requireCurrentUser
import org.koin.ktor.ext.inject
import kotlin.time.Duration.Companion.minutes

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
            data = request.userData,
            deviceNotificationsToken = request.deviceNotificationsToken,
            pictureUrl = null,
            emailVerification = tokenVerificationService.generate(10.minutes),
            forgotPasswordVerification = null,
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
            "${call.request.baseUrl()}/auth/verifyEmail?email=${user.email}&token=${user.emailVerification?.token}"

        val sendEmailSuccess = emailSenderService.sendEmail(
            EmailMessage(
                to = user.email,
                subject = "Email account verification link",
                body = "Hi, you have sign up on our platform,\n" +
                        " to confirm your email, we need you to open this link\n" +
                        "$verificationLink\n\nif you didn't do that," +
                        " please ignore this message"
            )
        )
        if (!sendEmailSuccess) {
            throw ErrorResponseException(
                HttpStatusCode.InternalServerError,
                "An error occurred while sending the email verification link, please try again by sign in or contact us",
                "UNKNOWN_ERROR"
            )
        }

        val accessToken = jwtService.generateAccessToken(user.id.toString())

        call.respond(
            HttpStatusCode.Created,
            AuthenticatedUserResponse(
                accessToken = accessToken.token,
                refreshToken = "",
                user = user.toResponse()
            )
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
            "USER_NOT_FOUND",
        )*/

        val isValidPassword = bcryptHashingService.verify(request.password, user.password)
        if (!isValidPassword) {
            throw ErrorResponseException(
                HttpStatusCode.Unauthorized,
                "Incorrect email or password",
                "INVALID_CREDENTIALS"
            )
        }

        request.deviceNotificationsToken?.let {
            userDataSource.updateDeviceNotificationsTokenById(
                deviceNotificationsToken = it,
                userId = user.id.toString()
            )
        }

        val accessToken = jwtService.generateAccessToken(userId = user.id.toString())

        call.respond(
            AuthenticatedUserResponse(
                accessToken = accessToken.token,
                refreshToken = "",
                user = user.toResponse()
            )
        )
    }
}

fun Route.verifyEmail() {
    val userDataSource by inject<UserDataSource>()

    post("/verifyEmail") {
        val token: String by call.request.queryParameters
        val email: String by call.request.queryParameters

        if (!email.isValidEmailAddress()) {
            throw ErrorResponseException(
                HttpStatusCode.BadRequest,
                "Please enter a valid email address",
                "INVALID_EMAIL"
            )
        }

        val user = userDataSource.findUserByEmail(email).getOrElse {
            throw ErrorResponseException(
                HttpStatusCode.InternalServerError,
                "Unknown error while trying to find this user with this email",
                "UNKNOWN_ERROR"
            )
        } ?: throw ErrorResponseException(HttpStatusCode.NotFound, "We couldn't find this user.", "USER_NOT_FOUND")

        if (user.isEmailVerified) throw ErrorResponseException(
            HttpStatusCode.Conflict,
            "Account is already verified.",
            "ALREADY_VERIFIED",
        )

        val emailVerification = user.emailVerification ?: throw ErrorResponseException(
            HttpStatusCode.InternalServerError,
            "You didn't request email verification, is the email is already verified? if yes then why we reached this state?",
            "INVALID_STATE"
        )

        if (emailVerification.hasTokenExpired()) throw ErrorResponseException(
            HttpStatusCode.Gone,
            "Token has expired.",
            "TOKEN_EXPIRED"
        )

        if (token != emailVerification.token) throw ErrorResponseException(
            HttpStatusCode.Unauthorized,
            "Token is invalid",
            "INVALID_TOKEN"
        )

        val isVerifyEmailSuccess = userDataSource.verifyEmail(email)
        if (!isVerifyEmailSuccess) throw ErrorResponseException(
            HttpStatusCode.InternalServerError,
            "Error while verify the email",
            "UNKNOWN_ERROR"
        )

        call.respondText { "Email has been successfully verified" }

    }
}

fun Route.deleteSelfAccount() {
    val userDataSource by inject<UserDataSource>()
    authenticate {
        delete("/deleteAccount") {
            val user = call.requireCurrentUser()
            val isDeleteSuccess = userDataSource.deleteUserById(user.id.toString())
            if (!isDeleteSuccess) throw ErrorResponseException(
                HttpStatusCode.InternalServerError,
                "Error while deleting the user.",
                "UNKNOWN_ERROR"
            )
            call.respondText { "User has been successfully deleted." }
        }
    }
}

fun Route.updatePassword() {
    val userDataSource by inject<UserDataSource>()
    val bcryptHashingService by inject<BcryptHashingService>()

    authenticate {
        post("/updatePassword") {
            val requestBody: Map<String, String> = call.receive()
            val currentPassword: String = requestBody["currentPassword"] ?: throw ErrorResponseException(
                HttpStatusCode.BadRequest,
                "Please enter the current password",
                "MISSING_CURRENT_PASSWORD"
            )
            val newPassword: String = requestBody["newPassword"] ?: throw ErrorResponseException(
                HttpStatusCode.BadRequest,
                "Please enter the new password",
                "MISSING_NEW_PASSWORD"
            )

            if (currentPassword == newPassword) {
                throw ErrorResponseException(
                    HttpStatusCode.BadRequest, "Please choose a new password", "IDENTICAL_PASSWORD"
                )
            }

            if (!newPassword.isValidPassword()) {
                throw ErrorResponseException(
                    HttpStatusCode.BadRequest, "Please enter a strong password",
                    "WEAK_PASSWORD"
                )
            }

            val user = call.requireCurrentUser()

            val isCurrentPasswordValid = bcryptHashingService.verify(currentPassword, user.password)

            if (!isCurrentPasswordValid) {
                throw ErrorResponseException(
                    HttpStatusCode.Unauthorized,
                    "Current password is incorrect.",
                    "INCORRECT_PASSWORD"
                )
            }

            val isUpdateSuccess = userDataSource.updateUserPasswordById(
                user.id.toString(),
                bcryptHashingService.generatedSaltedHash(newPassword)
            )

            if (!isUpdateSuccess) {
                throw ErrorResponseException(
                    HttpStatusCode.InternalServerError,
                    "Error while update the password.",
                    "UPDATE_ERROR"
                )
            }

            call.respondText { "Password has been successfully updated." }
        }
    }
}

fun Route.updateDeviceNotificationsToken() {
    val userDataSource by inject<UserDataSource>()
    authenticate {
        patch("/updateDeviceNotificationsToken") {
            val requestBody: Map<String, String> = call.receive()
            val firebase: String = requestBody["firebase"] ?: throw ErrorResponseException(
                HttpStatusCode.BadRequest, "Please enter the firebase notifications token.", "MISSING_FCM_TOKEN"
            )
            val oneSignal: String = requestBody["oneSignal"] ?: throw ErrorResponseException(
                HttpStatusCode.BadRequest, "Please enter the oneSignal notifications token", "MISSING_ONESIGNAL_TOKEN"
            )

            val currentUser = call.requireCurrentUser()
            val isUpdateSuccess = userDataSource.updateDeviceNotificationsTokenById(
                deviceNotificationsToken = UserDeviceNotificationsToken(
                    firebase, oneSignal
                ),
                userId = currentUser.id.toString()
            )

            if (!isUpdateSuccess) {
                throw ErrorResponseException(
                    HttpStatusCode.InternalServerError,
                    "Error while updating the device notifications token",
                    "UNKNOWN_ERROR"
                )
            }

            call.respondText { "Device notifications token has been successfully updated." }
        }
    }
}