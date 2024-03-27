package net.freshplatform.routes.auth

import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.html.*
import io.ktor.server.request.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import io.ktor.server.util.*
import kotlinx.html.*
import net.freshplatform.Constants
import net.freshplatform.data.user.UserDataSource
import net.freshplatform.services.email_sender.EmailMessage
import net.freshplatform.services.email_sender.EmailSenderService
import net.freshplatform.services.security.hashing.BcryptHashingService
import net.freshplatform.services.security.token_verification.TokenVerificationService
import net.freshplatform.utils.ErrorResponseException
import net.freshplatform.utils.extensions.baseUrl
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
            userId = user.id.toString(),
            token = resetPasswordVerification.token // Use this instead of the one from user
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
        val userId: String = requestBody["userId"] ?: throw ErrorResponseException(
            HttpStatusCode.BadRequest,
            "The user id is required for resetting the password",
            "MISSING_USER_ID"
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

        val user = userDataSource.findUserById(userId).getOrElse {
            throw ErrorResponseException(
                HttpStatusCode.InternalServerError,
                "Unknown error while getting a user with this user id.",
                "UNKNOWN_ERROR",
            )
        } ?: throw ErrorResponseException(
            HttpStatusCode.NotFound,
            "There is no user with this user id.",
            "USER_NOT_FOUND"
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

fun Route.resetPasswordForm() {
    val resetPasswordRoutePath = "/auth/resetPassword" // Hardcoded

    get("/resetPasswordForm") {
        val token: String by call.request.queryParameters
        val userId: String by call.request.queryParameters
        call.respondHtml {
            head {
                title("Reset password")
                meta(charset = "UTF-8")
                meta("viewport", "user-scalable=no, width=device-width, initial-scale=1.0")
                meta("apple-mobile-web-app-capable", "yes")
                style {
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
                        width: 300px;
                        background-color: #fff;
                        border-radius: 8px;
                        padding: 20px;
                        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                    }
                
                    h2 {
                        margin-top: 0;
                        color: #333;
                    }
                
                    input {
                        border: 2px solid #d3d3d3;
                        background-color: #f0f0f0;
                        border-radius: 6px;
                        font-size: 18px;
                        padding: 12px;
                        transition: border-color 150ms, box-shadow 200ms;
                        width: 90%;
                    }
                    
                    input::placeholder {
                        color: #6c757d;
                        font-weight: normal;
                    }
                    
                    input:focus {
                        border: 3px solid #007bff;
                        outline: none;
                        box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
                    }
                
                    button {
                        width: 100%;
                        padding: 10px;
                        background-color: #007bff;
                        color: #fff;
                        border: none;
                        border-radius: 4px;
                        cursor: pointer;
                        transition: background-color 0.3s ease;
                    }
                
                    button:hover {
                        background-color: #0056b3;
                    }
                    """.trimIndent()
                }
            }
            body {
                div(classes = "container") {
                    h2 { +"Reset password" }
                    form {
                        passwordInput {
                            placeholder = "New password"
                            required = true
                            pattern = Constants.Patterns.PASSWORD
                        }
                        div {
                            style = "padding-top: 10px"
                        }
                        button(type = ButtonType.submit) { +"Update Password" }
                    }
                }
                script {
                    +"""
                        document.querySelector('form').addEventListener('submit', async function (event) {
                        event.preventDefault();
                        const newPassword = document.querySelector('input[type=password]').value;
                        const requestBody = {
                            token: '$token',
                            userId: '$userId',
                            newPassword: newPassword
                        };
                        try {
                            const response = await fetch('$resetPasswordRoutePath', {
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