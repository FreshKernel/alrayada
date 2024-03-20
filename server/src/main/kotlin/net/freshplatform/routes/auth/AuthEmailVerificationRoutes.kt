package net.freshplatform.routes.auth

import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import io.ktor.server.util.*
import net.freshplatform.data.user.UserDataSource
import net.freshplatform.services.email_sender.EmailMessage
import net.freshplatform.services.email_sender.EmailSenderService
import net.freshplatform.services.security.token_verification.TokenVerificationService
import net.freshplatform.utils.ErrorResponseException
import net.freshplatform.utils.extensions.baseUrl
import net.freshplatform.utils.extensions.isValidEmailAddress
import net.freshplatform.utils.extensions.requireCurrentUser
import org.koin.ktor.ext.inject

fun Route.sendEmailVerificationLink() {
    val userDataSource by inject<UserDataSource>()
    val tokenVerificationService by inject<TokenVerificationService>()
    val emailSenderService by inject<EmailSenderService>()

    authenticate {
        post("/sendEmailVerificationLink") {
            val currentUser = call.requireCurrentUser()

            if (currentUser.isEmailVerified) throw ErrorResponseException(
                HttpStatusCode.Conflict,
                "Email is already verified.",
                "EMAIL_ALREADY_VERIFIED",
            )

            currentUser.emailVerification?.let {
                if (!it.hasTokenExpired()) {
                    throw ErrorResponseException(
                        HttpStatusCode.Conflict,
                        "The email verification token hasn't expired yet.",
                        "EMAIL_VERIFICATION_LINK_ALREADY_SENT",
                        mapOf("minutesToExpire" to it.minutesToExpire().toString())
                    )
                }
            }

            val emailVerification = tokenVerificationService.generate(
                AuthUtils.EMAIL_VERIFICATION_TOKEN_EXPIRATION
            )

            val isUpdateSuccess = userDataSource.updateEmailVerificationStatusById(
                currentUser.id.toString(),
                emailVerification
            )

            if (!isUpdateSuccess) {
                throw ErrorResponseException(
                    HttpStatusCode.InternalServerError,
                    "Unknown error while updating the email verification object in the database.",
                    "UNKNOWN_ERROR"
                )
            }

            val verificationLink =
                AuthUtils.createEmailVerificationLink(
                    baseUrl = call.request.baseUrl(),
                    email = currentUser.email,
                    emailVerificationToken = emailVerification.token // Use this instead of the one from currentUser
                )

            val isSendEmailSuccess = emailSenderService.sendEmail(
                EmailMessage(
                    to = currentUser.email,
                    subject = "Verify your email account",
                    body = "Hi, you have requested to verify your email address.\n" +
                            " To confirm your email, please open the following link:\n" +
                            "$verificationLink\n\nIf you didn't request this verification," +
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

            call.respondText { "We have successfully sent email verification link. Please check your email inbox" }

        }
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
        } ?: throw ErrorResponseException(HttpStatusCode.NotFound, "We couldn't find this user.", "EMAIL_NOT_FOUND")

        if (user.isEmailVerified) throw ErrorResponseException(
            HttpStatusCode.Conflict,
            "Email is already verified.",
            "EMAIL_ALREADY_VERIFIED",
        )

        // The emailVerification will be null once we verify the email
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