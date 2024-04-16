package net.freshplatform.routes.user

import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.request.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import net.freshplatform.data.user.UserDataSource
import net.freshplatform.data.user.UserInfo
import net.freshplatform.utils.ErrorResponseException
import net.freshplatform.utils.extensions.requireCurrentUser
import org.koin.ktor.ext.inject

fun Route.getUserData() {
    authenticate {
        get("/userData") {
            call.respond(HttpStatusCode.OK, call.requireCurrentUser().toResponse())
        }
    }
}

fun Route.updateUserInfo() {
    val userDataSource by inject<UserDataSource>()
    authenticate {
        patch("/updateUserInfo") {
            val userInfo = call.receive<UserInfo>()
            val error = userInfo.validate()

            if (error != null) {
                throw ErrorResponseException(HttpStatusCode.BadRequest, error.first, error.second)
            }

            val user = call.requireCurrentUser()
            val isUpdateSuccess = userDataSource.updateUserInfoById(user.id.toString(), userInfo)

            if (!isUpdateSuccess) {
                throw ErrorResponseException(
                    HttpStatusCode.InternalServerError,
                    "Unknown error while updating the user info data.",
                    "UNKNOWN_ERROR"
                )
            }

            call.respondText { "User info has been updated successfully." }
        }
    }
}