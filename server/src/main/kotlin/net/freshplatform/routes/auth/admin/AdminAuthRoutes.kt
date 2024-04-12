package net.freshplatform.routes.auth.admin

import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.request.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import io.ktor.server.util.*
import net.freshplatform.data.user.User
import net.freshplatform.data.user.UserDataSource
import net.freshplatform.services.notifications.NotificationsService
import net.freshplatform.utils.ErrorResponseException
import net.freshplatform.utils.extensions.requireCurrentAdminUser
import org.koin.ktor.ext.inject

fun Route.adminAuthRoutes() {
    route("/admin") {
        getAllUsers()
        deleteUserAccount()
        setAccountActivated()
        sendNotificationToUser()
    }
}

fun Route.getAllUsers() {
    val userDataSource by inject<UserDataSource>()
    authenticate {
        get("/users") {
            val currentUser = call.requireCurrentAdminUser() // Important
            val searchQuery: String by call.request.queryParameters
            val page: Int by call.request.queryParameters
            val limit: Int by call.request.queryParameters
            val users = userDataSource.getAllUsers(page, limit, searchQuery).getOrElse {
                throw ErrorResponseException(
                    HttpStatusCode.InternalServerError,
                    "Unknown error while getting the users: ${it.message}",
                    "COULD_NOT_LOAD_USERS"
                )
            }.map { it.toResponse() }.filterNot { it.userId == currentUser.id.toString() }
            call.respond(HttpStatusCode.OK, users)
        }
    }
}

fun Route.deleteUserAccount() {
    val userDataSource by inject<UserDataSource>()
    authenticate {
        delete("/deleteUser") {
            val currentUser = call.requireCurrentAdminUser() // Important
            val requestBody: Map<String, String> = call.receive()
            val userId = requestBody["userId"] ?: throw ErrorResponseException(
                HttpStatusCode.BadRequest,
                "The user id is required",
                "MISSING_USER_ID",
            )
            if (currentUser.id.toString() == userId) {
                throw ErrorResponseException(
                    HttpStatusCode.BadRequest, "We can't let you delete yourself :)", "NO"
                )
            }
            val isDeleteSuccess = userDataSource.deleteUserById(userId)
            if (!isDeleteSuccess) {
                throw ErrorResponseException(
                    HttpStatusCode.InternalServerError,
                    "Error while deleting the user from database.",
                    "COULD_NOT_DELETE_USER"
                )
            }
            call.respondText("User account has been successfully deleted.", status = HttpStatusCode.NoContent)
        }
    }
}

fun Route.setAccountActivated() {
    val userDataSource by inject<UserDataSource>()
    val notificationsService by inject<NotificationsService>()
    authenticate {
        patch("/setAccountActivated") {
            call.requireCurrentAdminUser() // Important
            val requestBody: Map<String, String> = call.receive()
            val userId = requestBody["userId"] ?: throw ErrorResponseException(
                HttpStatusCode.BadRequest,
                "The user id is required",
                "MISSING_USER_ID",
            )
            val isAccountActivatedNew =
                requestBody["value"]?.toBooleanStrictOrNull() ?: throw ErrorResponseException(
                    HttpStatusCode.BadRequest,
                    "The isAccountActivated is missing or invalid boolean",
                    "MISSING_IS_ACCOUNT_ACTIVATED",
                )
            val currentIsAccountActivated = userDataSource.isAccountActivatedById(userId).getOrElse {
                throw ErrorResponseException(
                    HttpStatusCode.InternalServerError,
                    "Unknown error while checking if the user account activated or not",
                    "UNKNOWN_ERROR",
                )
            }
            if (currentIsAccountActivated == null) {
                throw ErrorResponseException(
                    HttpStatusCode.NotFound,
                    "We can't find this user or the ${User::isAccountActivated.name} property",
                    "MISSING_DATA"
                )
            }

            if (isAccountActivatedNew) {
                // The admin want to activate the user account

                if (currentIsAccountActivated) {
                    throw ErrorResponseException(
                        HttpStatusCode.Conflict,
                        "The user account is already activated.",
                        "ALREADY_ACTIVATED",
                    )
                }
                val isUpdateSuccess = userDataSource.setAccountActivatedById(userId, true)
                if (!isUpdateSuccess) {
                    throw ErrorResponseException(
                        HttpStatusCode.InternalServerError,
                        "Unknown server error while activate the user account",
                        "UNKNOWN_ERROR"
                    )
                }

                call.respondText { "User account has been successfully activated." }

                userDataSource.findUserDeviceNotificationsTokenById(userId).getOrNull()?.let {
                    notificationsService.sendToDevice(
                        title = "Account activated!",
                        body = "Your account has been activated.",
                        deviceNotificationsToken = it
                    )
                }
                return@patch
            }

            // The admin want to deactivate the user account

            if (!currentIsAccountActivated) {
                throw ErrorResponseException(
                    HttpStatusCode.Conflict,
                    "The user account is already not activated.",
                    "ALREADY_NOT_ACTIVATED",
                )
            }

            val isUpdateSuccess = userDataSource.setAccountActivatedById(userId, false)
            if (!isUpdateSuccess) {
                throw ErrorResponseException(
                    HttpStatusCode.InternalServerError,
                    "Unknown server error while deactivate the user account",
                    "UNKNOWN_ERROR"
                )
            }

            call.respondText { "User account has been successfully deactivated." }
        }
    }
}

fun Route.sendNotificationToUser() {
    val userDataSource by inject<UserDataSource>()
    val notificationsService by inject<NotificationsService>()
    authenticate {
        post("/sendNotificationToUser") {
            call.requireCurrentAdminUser() // Important
            val requestBody: Map<String, String> = call.receive()
            val title: String = requestBody["title"] ?: throw ErrorResponseException(
                HttpStatusCode.BadRequest, "Notifications title is missing.", "MISSING_TITLE"
            )
            val body: String = requestBody["body"] ?: throw ErrorResponseException(
                HttpStatusCode.BadRequest, "Notifications body is missing.", "MISSING_BODY"
            )
            val userId: String = requestBody["userId"] ?: throw ErrorResponseException(
                HttpStatusCode.BadRequest, "User id is missing.", "MISSING_USER_ID"
            )
            val user = userDataSource.findUserById(userId).getOrElse {
                throw ErrorResponseException(
                    HttpStatusCode.InternalServerError,
                    "Unknown error while getting the user from the database: ${it.message}",
                    "CANT_FIND_USER"
                )
            } ?: throw ErrorResponseException(
                HttpStatusCode.NotFound, "Can't find a user with this user id", "USER_NOT_FOUND"
            )
            val messageId = notificationsService.sendToDevice(
                title = title,
                body = body,
                deviceNotificationsToken = user.deviceNotificationsToken
            ).getOrElse {
                throw ErrorResponseException(
                    HttpStatusCode.InternalServerError,
                    "Unknown error while sending the message to notifications server: ${it.message}",
                    "NOTIFICATION_SERVER_ERROR"
                )
            }
            call.respondText { "Notification has been successfully sent to the user, message id: $messageId" }
        }
    }
}