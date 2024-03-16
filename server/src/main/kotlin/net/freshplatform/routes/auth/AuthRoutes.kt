package net.freshplatform.routes.auth

import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.request.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import net.freshplatform.data.user.UserDataSource
import net.freshplatform.data.user.UserDeviceNotificationsToken
import net.freshplatform.utils.ErrorResponseException
import net.freshplatform.utils.extensions.requireCurrentUser
import org.koin.ktor.ext.inject

fun Route.deleteSelfAccount() {
    val userDataSource by inject<UserDataSource>()
    authenticate {
        delete("/deleteAccount") {
            val currentUser = call.requireCurrentUser()
            val isDeleteSuccess = userDataSource.deleteUserById(currentUser.id.toString())
            if (!isDeleteSuccess) throw ErrorResponseException(
                HttpStatusCode.InternalServerError,
                "Error while deleting the user.",
                "UNKNOWN_ERROR"
            )
            call.respondText { "User has been successfully deleted." }
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