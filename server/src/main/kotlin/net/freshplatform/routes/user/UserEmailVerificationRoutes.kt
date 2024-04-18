package net.freshplatform.routes.user

import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.html.*
import io.ktor.server.request.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import io.ktor.server.util.*
import kotlinx.html.*
import net.freshplatform.data.user.UserDataSource
import net.freshplatform.services.email_sender.EmailMessage
import net.freshplatform.services.email_sender.EmailSenderService
import net.freshplatform.services.security.token_verification.TokenVerificationService
import net.freshplatform.utils.ErrorResponseException
import net.freshplatform.utils.extensions.baseUrl
import net.freshplatform.utils.extensions.requireCurrentUser
import org.koin.ktor.ext.inject

fun Route.sendEmailVerificationLink() {
    val userDataSource by inject<UserDataSource>()
    val tokenVerificationService by inject<TokenVerificationService>()
    val emailSenderService by inject<EmailSenderService>()

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
            UserUtils.EMAIL_VERIFICATION_TOKEN_EXPIRATION
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
            UserUtils.createEmailVerificationLink(
                baseUrl = call.request.baseUrl(),
                userId = currentUser.id.toString(),
                token = emailVerification.token // Use this instead of the one from currentUser
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

fun Route.verifyEmail() {
    val userDataSource by inject<UserDataSource>()

    // When you change the route path, you also need to change it from `verifyEmailForm` route
    post("/verifyEmail") {
        val requestBody: Map<String, String> = call.receive()
        val token: String = requestBody["token"] ?: throw ErrorResponseException(
            HttpStatusCode.BadRequest, "The token is required.", "MISSING_TOKEN"
        )
        val userId: String = requestBody["userId"] ?: throw ErrorResponseException(
            HttpStatusCode.BadRequest, "The user id is required.", "MISSING_USER_ID"
        )

        val user = userDataSource.findUserById(userId).getOrElse {
            throw ErrorResponseException(
                HttpStatusCode.InternalServerError,
                "Unknown error while trying to find this user with this user id",
                "UNKNOWN_ERROR"
            )
        } ?: throw ErrorResponseException(HttpStatusCode.NotFound, "There is no user with this id", "USER_NOT_FOUND")

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

        val isVerifyEmailSuccess = userDataSource.verifyUserEmailById(userId)
        if (!isVerifyEmailSuccess) throw ErrorResponseException(
            HttpStatusCode.InternalServerError,
            "Error while verify the email",
            "UNKNOWN_ERROR"
        )

        call.respondText { "Email has been successfully verified" }

    }
}

fun Route.verifyEmailForm() {
    val verifyEmailRoutePath = "/user/verifyEmail" // Hardcoded

    // When you change the route path, you also need to change it from `AuthUtils` class
    get("/verifyEmailForm") {
        val token: String by call.request.queryParameters
        val userId: String by call.request.queryParameters
        call.respondHtml {
            head {
                title("Verify your email")
                meta(charset = "UTF-8")
                meta("viewport", "user-scalable=no, width=device-width, initial-scale=1.0")
                meta("apple-mobile-web-app-capable", "yes")
                style {
                    unsafe {
                        +"""
                        body {
                        font-family: Arial, sans-serif;
                        background-color: #f4f4f4;
                        margin: 0;
                        padding: 0;
                        display: flex;
                        justify-content: center;
                        align-items: center;
                        height: 100vh;
                    }
                
                    .container {
                        background-color: #fff;
                        border-radius: 8px;
                        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
                        padding: 20px;
                        text-align: center;
                    }
                
                    h1 {
                        margin-top: 0;
                        color: #333;
                    }
                
                    p {
                        margin-bottom: 20px;
                        color: #666;
                    }
                
                    button {
                        background-color: #007bff;
                        color: #fff;
                        border: none;
                        border-radius: 4px;
                        padding: 10px 20px;
                        font-size: 16px;
                        cursor: pointer;
                        transition: background-color 0.3s;
                    }
                
                    button:hover {
                        background-color: #0056b3;
                    }
                    """.trimIndent()
                    }
                }
            }
            body {
                div(classes = "container") {
                    h1 { +"Verify Email" }
                    p { +"Please click the button below to verify your email:" }
                    form {
                        button(type = ButtonType.submit) { +"Verify Email" }
                    }
                }
                script {
                    unsafe {
                        +"""
                        document.querySelector('form').addEventListener('submit', async function (event) {
                        event.preventDefault();
                        const requestBody = {
                            token: '$token',
                            userId: '$userId'
                        };
                        try {
                            const response = await fetch('$verifyEmailRoutePath', {
                                method: 'POST',
                                headers: {
                                    'Content-Type': 'application/json'
                                },
                                body: JSON.stringify(requestBody)
                            });
                            const responseText = await response.text();
                            if (!response.ok) {
                                alert(`Error while verifying the email: ${"$"}{responseText}`);
                                console.error(responseText);
                                return;
                            }
                    
                            alert(responseText);
                            window.location.href = 'https://www.google.com';
                        } catch (error) {
                            console.error(error);
                            alert(error);
                        }
                    });
                    """.trimIndent()
                    }
                }
            }
        }
    }
}