package net.freshplatform.utils.extensions

import io.ktor.server.websocket.*
import io.ktor.websocket.*
import net.freshplatform.data.user.User
import net.freshplatform.data.user.UserDataSource
import org.koin.ktor.ext.inject

suspend fun WebSocketServerSession.requireCurrentUser(): User {
    val userId = call.getCurrentUserNullableId() ?: kotlin.run {
        close(
            CloseReason(
                CloseReason.Codes.VIOLATED_POLICY,
                "You need to be authenticated in order to connect."
            )
        )
        throw NullPointerException("The user id is null")
    }
    val userDataSource by call.application.inject<UserDataSource>()
    val user = userDataSource.findUserById(userId).getOrElse {
        close(
            CloseReason(
                CloseReason.Codes.VIOLATED_POLICY,
                "Unknown error while trying to the user from database."
            )
        )
        throw it
    } ?: kotlin.run {
        close(
            CloseReason(
                CloseReason.Codes.VIOLATED_POLICY,
                "There is no user with this id"
            )
        )
        throw NoSuchElementException("There is no user with this id: $userId")
    }
    return user
}