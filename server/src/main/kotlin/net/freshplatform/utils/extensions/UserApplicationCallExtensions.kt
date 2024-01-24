package net.freshplatform.utils.extensions

import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.auth.jwt.*
import net.freshplatform.data.user.User
import net.freshplatform.data.user.UserDataSource
import org.koin.ktor.ext.inject

suspend fun ApplicationCall.getCurrentUserNullable(): User? {
    val userID = principal<JWTPrincipal>()?.subject ?: return null
    val userDataSource by inject<UserDataSource>()
    val user = userDataSource.findUserById(userID)
    return user
}

class AuthorizationRequiredException: Exception("User is required to be authenticated")

suspend fun ApplicationCall.getCurrentUser(): User {
    return getCurrentUserNullable() ?: throw AuthorizationRequiredException()
}