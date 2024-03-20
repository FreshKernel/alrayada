package net.freshplatform.routes.auth

import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.request.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import net.freshplatform.data.user.UserDataSource
import net.freshplatform.services.email_sender.EmailMessage
import net.freshplatform.services.email_sender.EmailSenderService
import net.freshplatform.services.security.hashing.BcryptHashingService
import net.freshplatform.services.security.token_verification.TokenVerificationService
import net.freshplatform.utils.ErrorResponseException
import net.freshplatform.utils.extensions.baseUrl
import net.freshplatform.utils.extensions.isValidEmailAddress
import net.freshplatform.utils.extensions.isValidPassword
import net.freshplatform.utils.extensions.requireCurrentUser
import org.koin.ktor.ext.inject

fun Route.sendResetPasswordLink() {
    val userDataSource by inject<UserDataSource>()
    val tokenVerificationService by inject<TokenVerificationService>()
    val emailSenderService by inject<EmailSenderService>()

    post("/sendResetPasswordLink") {
        val requestBody: Map<String, String> = call.receive()
        val email = requestBody["email"] ?: throw ErrorResponseException(
            HttpStatusCode.BadRequest,
            "The email is required",
            "MISSING_EMAIL",
        )

        val user = userDataSource.findUserByEmail(email).getOrElse {
            throw ErrorResponseException(
                HttpStatusCode.InternalServerError,
                "Unknown error while getting a user with this email.",
                "UNKNOWN_ERROR",
            )
        } ?: throw ErrorResponseException(
            HttpStatusCode.NotFound,
            "There is no user with this email.",
            "EMAIL_NOT_FOUND"
        )

        user.resetPasswordVerification?.let {
            if (!it.hasTokenExpired()) {
                throw ErrorResponseException(
                    HttpStatusCode.Conflict,
                    "The reset password token hasn't expired yet.",
                    "RESET_PASSWORD_LINK_ALREADY_SENT",
                    mapOf("minutesToExpire" to it.minutesToExpire().toString())
                )
            }
        }

        val resetPasswordVerification = tokenVerificationService.generate(
            AuthUtils.RESET_PASSWORD_VERIFICATION_TOKEN_EXPIRATION
        )

        val isUpdateSuccess =
            userDataSource.updateResetPasswordVerificationStatusById(user.id.toString(), resetPasswordVerification)

        if (!isUpdateSuccess) {
            throw ErrorResponseException(
                HttpStatusCode.InternalServerError,
                "Unknown error while updating the reset password verification object in the database.",
                "UNKNOWN_ERROR"
            )
        }

        val resetLink = AuthUtils.createResetPasswordLink(
            baseUrl = call.request.baseUrl(),
            email = user.email,
            resetPasswordVerificationToken = resetPasswordVerification.token // Use this instead of the one from user
        )

        val isSendEmailSuccess = emailSenderService.sendEmail(
            EmailMessage(
                to = user.email,
                subject = "Reset your password",
                body = "Hi, you have requested to reset your password.\n" +
                        " To reset your password, please click the following link:\n" +
                        "$resetLink\n\nIf you didn't request this change," +
                        " please ignore this message."
            )
        )

        if (!isSendEmailSuccess) {
            throw ErrorResponseException(
                HttpStatusCode.InternalServerError,
                "Unknown error while sending email verification to your email. Please try again later or contact us.",
                "UNKNOWN_ERROR"
            )
        }

        call.respondText { "We have successfully sent reset password link. Please check your email inbox" }
    }
}

fun Route.resetPassword() {
    val userDataSource by inject<UserDataSource>()
    val bcryptHashingService by inject<BcryptHashingService>()

    post("/resetPassword") {
        val requestBody: Map<String, String> = call.receive()
        val email: String = requestBody["email"] ?: throw ErrorResponseException(
            HttpStatusCode.BadRequest,
            "The email is required for resetting the password",
            "MISSING_EMAIL"
        )
        val token: String = requestBody["token"] ?: throw ErrorResponseException(
            HttpStatusCode.BadRequest,
            "The token is required for resetting the password",
            "MISSING_TOKEN"
        )
        val newPassword: String = requestBody["newPassword"] ?: throw ErrorResponseException(
            HttpStatusCode.BadRequest,
            "The token is required for resetting the password",
            "MISSING_NEW_PASSWORD"
        )

        if (!newPassword.isValidPassword()) {
            throw ErrorResponseException(
                HttpStatusCode.BadRequest, "Please enter a strong password.",
                "WEAK_PASSWORD"
            )
        }

        if (email.isValidEmailAddress()) {
            throw ErrorResponseException(
                HttpStatusCode.BadRequest, "Please enter a valid email address.",
                "INVALID_EMAIL"
            )
        }

        val user = userDataSource.findUserByEmail(email).getOrElse {
            throw ErrorResponseException(
                HttpStatusCode.InternalServerError,
                "Unknown error while getting a user with this email.",
                "UNKNOWN_ERROR",
            )
        } ?: throw ErrorResponseException(
            HttpStatusCode.NotFound,
            "There is no user with this email.",
            "EMAIL_NOT_FOUND"
        )

        val resetPasswordVerification = user.resetPasswordVerification ?: throw ErrorResponseException(
            HttpStatusCode.InternalServerError,
            "You didn't request resting your password or you already did updated your password. Please request again",
            "RESET_PASSWORD_NOT_REQUESTED"
        )

        if (resetPasswordVerification.hasTokenExpired()) throw ErrorResponseException(
            HttpStatusCode.Forbidden,
            "The token has been expired.",
            "TOKEN_EXPIRED"
        )

        if (token != resetPasswordVerification.token) throw ErrorResponseException(
            HttpStatusCode.Unauthorized, "The entered token is incorrect", "INCORRECT_TOKEN"
        )

        val password = bcryptHashingService.generatedSaltedHash(newPassword)
        val isUpdateSuccess = userDataSource.resetPasswordById(user.id.toString(), password)

        if (!isUpdateSuccess) throw ErrorResponseException(
            HttpStatusCode.InternalServerError,
            "Unknown error while updating the password in the database.",
            "UNKNOWN_ERROR"
        )

        call.respondText { "Your password has been successfully updated." }
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
                    HttpStatusCode.BadRequest, "Please enter a strong password.",
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

            val isUpdateSuccess = userDataSource.updatePasswordById(
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