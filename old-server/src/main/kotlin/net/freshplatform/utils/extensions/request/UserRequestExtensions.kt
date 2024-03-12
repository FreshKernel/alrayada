package net.freshplatform.utils.extensions.request

import net.freshplatform.data.user.User
import net.freshplatform.data.user.UserDataSource
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.auth.jwt.*
import io.ktor.server.response.*
import org.koin.ktor.ext.inject

fun ApplicationCall.getCurrentUserId(): String? {
    val principal = this.principal<JWTPrincipal>()
    return principal?.getClaim("userId", String::class)
}

suspend fun ApplicationCall.getCurrentUserNullable(): User? {
    protectRouteToAppOnly()
    val userId = getCurrentUserId() ?: return null
    val userDataSource by this.inject<UserDataSource>()
    return userDataSource.getUserByUUID(userId)
}

class UserShouldAuthenticatedException: Exception("User must be authenticated.")
class AdminRequiredException: Exception("You don't have access to this route!")

@Throws(UserShouldAuthenticatedException::class)
suspend fun ApplicationCall.requireAuthenticatedUser(errorMessage: String = "You must be authenticated to continue."): User {
    return getCurrentUserNullable() ?: kotlin.run {
        this.respondJsonText(HttpStatusCode.Unauthorized, errorMessage)
        throw UserShouldAuthenticatedException()
    }
}

@Throws(AdminRequiredException::class)
suspend fun ApplicationCall.requireAdminUser(): User {
    val currentUser = this.getCurrentUserNullable()
    if (currentUser == null || !currentUser.hasAdminPrivileges()) {
        this.respond(HttpStatusCode.Forbidden, "You don't have access to this route!")
        throw AdminRequiredException()
    }
    return currentUser
}

fun ApplicationCall.generateEmailVerificationLink(email: String, token: String): String {
    return "${this.getServerClientUrl()}/api/authentication/verifyEmailAccount?token=${token}&email=${email}"
}

fun ApplicationCall.generateResetPasswordFormVerificationLink(email: String, token: String): String {
    return "${this.getServerClientUrl()}/api/authentication/resetPasswordForm?token=${token}&email=${email}"
}