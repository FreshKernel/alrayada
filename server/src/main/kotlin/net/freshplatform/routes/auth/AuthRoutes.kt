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
import net.freshplatform.services.email_sender.EmailSenderService
import net.freshplatform.services.security.hashing.BcryptHashingService
import net.freshplatform.services.security.jwt.JwtService
import net.freshplatform.services.security.token_verification.TokenVerificationService
import net.freshplatform.services.telegram_bot.TelegramBotService
import net.freshplatform.utils.ErrorResponseException
import net.freshplatform.utils.extensions.getCurrentUser
import net.freshplatform.utils.extensions.isValidEmailAddress
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

        val findUserByEmail = userDataSource.findUserByEmail(request.email).getOrElse {
            throw ErrorResponseException(
                HttpStatusCode.InternalServerError,
                "Unknown error while trying to find this user with this email",
                "UNKNOWN_ERROR"
            )
        }

        val user = findUserByEmail ?: throw ErrorResponseException(
            HttpStatusCode.NotFound,
            "Email not found. Please check your email address and try again.",
            "USER_NOT_FOUND",
        )

        val isValidPassword = bcryptHashingService.verify(request.password, user.password)
        if (!isValidPassword) {
            throw ErrorResponseException(
                HttpStatusCode.Unauthorized,
                "Incorrect email or password",
                "INVALID_CREDENTIALS"
            )
        }

        request.deviceNotificationsToken?.let {
            userDataSource.updateDeviceNotificationsToken(it, user.id.toString())
        }

        val accessToken = jwtService.generateAccessToken(user.id.toString())

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

    patch("/verifyEmail") {
        val token: String by call.request.queryParameters
        val email: String by call.request.queryParameters

        if (!email.isValidEmailAddress()) {
            throw ErrorResponseException(
                HttpStatusCode.BadRequest,
                "Please enter a valid email address",
                "INVALID_EMAIL"
            )
        }

        val findUserByEmail = userDataSource.findUserByEmail(email).getOrElse {
            throw ErrorResponseException(
                HttpStatusCode.InternalServerError,
                "Unknown error while trying to find this user with this email",
                "UNKNOWN_ERROR"
            )
        }

        val user = findUserByEmail
            ?: throw ErrorResponseException(HttpStatusCode.NotFound, "We couldn't find this user.", "USER_NOT_FOUND")

        if (user.isEmailVerified) throw ErrorResponseException(
            HttpStatusCode.Conflict,
            "Account is already verified.",
            "ALREADY_VERIFIED",
        )

        val emailVerification = user.emailVerification ?: throw ErrorResponseException(
            HttpStatusCode.InternalServerError,
            "You didn't request email verification, is the email is already verified?",
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
            val user = call.getCurrentUser()
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