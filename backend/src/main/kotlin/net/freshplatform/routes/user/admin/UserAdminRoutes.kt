package net.freshplatform.routes.user.admin

import net.freshplatform.data.user.UserDataSource
import net.freshplatform.services.notifications.NotificationService
import net.freshplatform.services.notifications.NotificationServiceException
import net.freshplatform.services.notifications.NotificationsServiceDeviceTokenEmptyException
import net.freshplatform.utils.extensions.request.*
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.response.*
import io.ktor.server.routing.*

class UserAdminRoutes(
    private val router: Route,
    private val userDataSource: UserDataSource,
    private val notificationService: NotificationService
) {
    fun getAllUsers() = router.authenticate {
        get("/") {
            val searchQuery = call.getParameter("searchQuery")
            call.requireAdminUser()
            val page = call.requestPageParameter()
            val limit = call.requestLimitParameter()
            val usersResponse =
                userDataSource.getAllUsers(limit, page, searchQuery = searchQuery).map { it.toResponse(call) }
            call.respond(HttpStatusCode.OK, usersResponse)
        }
    }

    // TODO("It is very important to recheck the server and make sure email is not included in the parameters!")

    fun sendNotification() = router.authenticate {
        post("/sendNotification") {
            call.requireAdminUser()
            val request = call.receiveBodyAs<NotificationRequest>()
            val requestError = request.validate()
            if (requestError != null) {
                call.respondJsonText(HttpStatusCode.BadRequest, requestError)
                return@post
            }
            val user = userDataSource.getUserByEmail(request.email) ?: kotlin.run {
                call.respondJsonText(HttpStatusCode.NotFound, "There is no user by this email.")
                return@post
            }
            try {
                val messageId = notificationService.sendToDevice(
                    title = request.title,
                    body = request.body,
                    deviceToken = user.deviceNotificationsToken
                )
                if (messageId == null) {
                    call.respondJsonText(HttpStatusCode.InternalServerError, "Unknown " +
                            "error from notification server, or maybe the device token is not" +
                            " valid.")
                    return@post
                }
                call.respondJsonText(HttpStatusCode.OK, "Notification has been successfully sent!")
            } catch (e: NotificationsServiceDeviceTokenEmptyException) {
                call.respondJsonText(HttpStatusCode.Conflict, "User have empty deviceToken.")
            } catch (e: NotificationServiceException) {
                call.respondJsonText(HttpStatusCode.InternalServerError, "Error while send notification: ${e.message}")
            }
        }
    }

    fun deleteAccount() = router.authenticate {
        delete("/deleteUser") {
            val currentUser = call.requireAdminUser()
            val request = call.receiveBodyAs<UserEmailRequest>()
            val error = request.validate()
            if (error != null) {
                call.respondJsonText(HttpStatusCode.BadRequest, error)
                return@delete
            }
            val email = request.email
            val user = userDataSource.getUserByEmail(email) ?: kotlin.run {
                call.respondJsonText(HttpStatusCode.Conflict, "There is no user by this email.")
                return@delete
            }
            println(user.email)
            println(currentUser.email)
            if (user.email == currentUser.email) {
                call.respondJsonText(HttpStatusCode.BadRequest, "We can't let you delete yourself!")
                return@delete
            }
            val deleteSuccess = userDataSource.deleteUserByUUID(user.uuid)
            if (!deleteSuccess) {
                call.respondJsonText("Error while delete the user.")
                return@delete
            }
            call.respondJsonText(HttpStatusCode.NoContent, "User account has been successfully deleted!")
        }
    }

    fun deactivateAccount() = router.authenticate {
        patch("/deactivateAccount") {
            call.requireAdminUser()
            val request = call.receiveBodyAs<UserEmailRequest>()
            val error = request.validate()
            if (error != null) {
                call.respondJsonText(HttpStatusCode.BadRequest, error)
                return@patch
            }
            val email = request.email
            val user = userDataSource.getUserByEmail(email) ?: kotlin.run {
                call.respondJsonText(HttpStatusCode.Conflict, "There is no user by this email.")
                return@patch
            }
            if (!user.accountActivated) {
                call.respondJsonText(HttpStatusCode.Conflict, "Account is already not activated.")
                return@patch
            }
            val updateSuccess = userDataSource.deactivateUserAccountByUUID(user.uuid)
            if (!updateSuccess) {
                call.respondJsonText(
                    HttpStatusCode.InternalServerError, "Error while deactivate " +
                            "user account."
                )
                return@patch
            }
            call.respondJsonText(HttpStatusCode.OK, "User account has been successfully deactivated.")
        }
    }

    fun activateAccount() = router.authenticate {
        patch("/activateAccount") {
            call.requireAdminUser()
            val request = call.receiveBodyAs<UserEmailRequest>()
            val error = request.validate()
            if (error != null) {
                call.respondJsonText(HttpStatusCode.BadRequest, error)
                return@patch
            }
            val email = request.email
            val user = userDataSource.getUserByEmail(email) ?: kotlin.run {
                call.respondJsonText(HttpStatusCode.Conflict, "There is no user by this email.")
                return@patch
            }
            if (user.accountActivated && user.emailVerified) {
                call.respondJsonText(HttpStatusCode.Conflict, "Account is already activated.")
                return@patch
            }
            val updateSuccess = userDataSource.activateUserAccountByUUID(user.uuid)
            if (!updateSuccess) {
                call.respondJsonText(
                    HttpStatusCode.InternalServerError, "Error while activate " +
                            "user account."
                )
                return@patch
            }
            try {
                notificationService.sendToDevice(
                    title = "Account activated!",
                    body = "Your account has been activated.",
                    deviceToken = user.deviceNotificationsToken
                )
            } catch (_: NotificationsServiceDeviceTokenEmptyException) {}
            catch (_: NotificationServiceException) {
//                call.respondJsonText(HttpStatusCode.InternalServerError, "Error while send notification")
            }
            println("Hello hello hello 2")
            call.respondJsonText(HttpStatusCode.OK, "User account has been successfully activated.")
        }
    }
}