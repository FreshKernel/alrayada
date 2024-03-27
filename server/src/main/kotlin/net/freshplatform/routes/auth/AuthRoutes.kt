package net.freshplatform.routes.auth

import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.plugins.ratelimit.*
import io.ktor.server.request.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import net.freshplatform.data.user.UserDataSource
import net.freshplatform.data.user.UserDeviceNotificationsToken
import net.freshplatform.routes.auth.admin.adminAuthRoutes
import net.freshplatform.utils.ErrorResponseException
import net.freshplatform.utils.extensions.requireCurrentUser
import org.koin.ktor.ext.inject

fun Route.authRoutes() {
    route("/auth") {
        // This RateLimitName is registered in the RateLimit plugin
        rateLimit(RateLimitName("auth")) {
            signUpWithEmailAndPassword()
            signInWithEmailAndPassword()
            socialLogin()
            sendEmailVerificationLink()
            verifyEmail()
            verifyEmailForm()
            deleteSelfAccount()
            updateDeviceNotificationsToken()
            getUserData()
            updateUserInfo()
            sendResetPasswordLink()
            resetPassword()
            resetPasswordForm()
            updatePassword()
        }
       adminAuthRoutes()
    }
}

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
            val deviceNotificationsToken = call.receive<UserDeviceNotificationsToken>()

            val currentUser = call.requireCurrentUser()
            val isUpdateSuccess = userDataSource.updateDeviceNotificationsTokenById(
                deviceNotificationsToken = deviceNotificationsToken,
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