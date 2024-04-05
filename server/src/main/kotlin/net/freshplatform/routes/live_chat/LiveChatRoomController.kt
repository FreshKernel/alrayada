package net.freshplatform.routes.live_chat

import io.ktor.server.websocket.*
import io.ktor.websocket.*
import kotlinx.datetime.Clock
import net.freshplatform.data.live_chat.ChatMessage
import net.freshplatform.data.live_chat.LiveChatDataSource
import java.util.*

private class Connection(
    val clientUserId: String,
    val session: DefaultWebSocketServerSession,
)

class LiveChatRoomController(
    private val liveChatDataSource: LiveChatDataSource,
) {
    private val connections = Collections.synchronizedSet<Connection>(LinkedHashSet())

    fun onJoin(clientUserId: String, session: DefaultWebSocketServerSession) {
        val connection = Connection(
            clientUserId = clientUserId,
            session = session,
        )
        if (!connections.contains(connection)) {
            connections += connection
            return
        }
    }

    /**
     * Insert the message in the database
     * then send it to all the connected users
     * */
    suspend fun sendMessage(
        clientUserId: String,
        senderId: String,
        text: String
    ) {
        val message = ChatMessage(
            text = text,
            senderId = senderId,
            createdAt = Clock.System.now(),
            updatedAt = Clock.System.now(),
        )
        // TODO: Handle the error when inserting the message
        val isSuccess = liveChatDataSource.insertMessage(
            clientUserId = clientUserId,
            message = message
        )
        connections.forEach { connection ->
            connection.session.sendSerialized(message.toResponse())
        }
    }

    /**
     * Close the web socket
     * Remove the connection if it exists
     * */
    suspend fun disconnect(
        clientUserId: String,
        socketSession: WebSocketSession
    ) {
        socketSession.close(CloseReason(CloseReason.Codes.NORMAL, "Disconnected"))
        val isRemoved = connections.removeIf { it.clientUserId == clientUserId }
    }
}