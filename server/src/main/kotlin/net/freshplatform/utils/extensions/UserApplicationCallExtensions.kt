package net.freshplatform.utils.extensions

import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.auth.jwt.*
import net.freshplatform.data.user.User
import net.freshplatform.data.user.UserDataSource
import net.freshplatform.utils.ErrorResponseException
import org.koin.ktor.ext.inject

fun ApplicationCall.getCurrentUserNullableId(): String? {
    val userId = principal<JWTPrincipal>()?.subject ?: return null
    return userId
}

suspend fun ApplicationCall.getCurrentNullableUser(): User? {
    val userId = getCurrentUserNullableId() ?: return null
    val userDataSource by inject<UserDataSource>()
    val user = userDataSource.findUserById(userId).getOrElse {
        throw ErrorResponseException(
            HttpStatusCode.InternalServerError,
            "Unknown error while trying to find a user with this user id",
            "UNKNOWN_ERROR"
        )
    }
    return user
}

/// Same as above but will require the user to be authenticated
suspend fun ApplicationCall.requireCurrentUser(): User {
    return getCurrentNullableUser() ?: throw ErrorResponseException(
        HttpStatusCode.Unauthorized,
        "You need to be authenticated to complete this action.",
        "UNAUTHENTICATED"
    )
}

suspend fun ApplicationCall.requireCurrentAdminUser(): User {
    val user = requireCurrentUser()
    if (!user.hasAdminPrivileges()) {
        throw ErrorResponseException(
            HttpStatusCode.Forbidden,
            "You don't have access to this route.",
            "NOT_ADMIN",
        )
    }
    return user
}