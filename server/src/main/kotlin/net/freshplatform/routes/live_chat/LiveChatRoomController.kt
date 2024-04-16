package net.freshplatform.routes.live_chat

import io.ktor.server.websocket.*
import io.ktor.websocket.*
import kotlinx.datetime.Clock
import net.freshplatform.data.live_chat.ChatMessage
import net.freshplatform.data.live_chat.LiveChatDataSource
import net.freshplatform.data.live_chat.LiveChatRoom
import java.util.*

/**
 * In memory room, the [LiveChatRoom] is in database
 * */
private class Room(
    val sessions: MutableList<DefaultWebSocketServerSession>,
)

class LiveChatRoomController(
    private val liveChatDataSource: LiveChatDataSource,
) {
    private val rooms = Collections.synchronizedMap<String, Room>(kotlin.collections.LinkedHashMap())

    fun roomsCount(): Int = rooms.count()

    /**
     * For simple debugging only
     * */
    fun roomsStatusMessage(): String {
        return buildString {
            rooms.forEach {
                append("Room key = ${it.key}, value = ${it.value.sessions.count()}")
            }
        }
    }

    /**
     * If the room doesn't exist, then create it and add the session of the user
     * If it exists, then check if there is a session, if not then add it, if there is
     * then will remove the old session and add the new one
     * */
    fun onJoin(roomClientUserId: String, session: DefaultWebSocketServerSession) {
        if (!rooms.containsKey(roomClientUserId)) {
            // The room doesn't exist
            rooms[roomClientUserId] = Room(mutableListOf(session))
            return
        }
        // The room exist
        val room = rooms[roomClientUserId]
        requireNotNull(room) {
            "The room $roomClientUserId doesn't exist anymore, maybe it's removed"
        }
        if (session in room.sessions) {
            room.sessions.remove(session)
        }
        room.sessions.add(session)

    }

    /**
     * Insert the message in the database
     * then send it to all the connected users
     * */
    suspend fun sendMessage(
        roomClientUserId: String,
        senderId: String,
        text: String
    ) {
        val message = ChatMessage(
            text = text,
            senderId = senderId,
            createdAt = Clock.System.now(),
            updatedAt = Clock.System.now(),
        )
        val isSuccess = liveChatDataSource.insertMessage(
            roomClientUserId = roomClientUserId,
            message = message
        )
        if (!isSuccess) {
            throw IllegalStateException("Unknown error while inserting a message to the database.")
        }
        val room = rooms[roomClientUserId]
        requireNotNull(room) {
            "The room $roomClientUserId doesn't exist anymore, maybe it's removed"
        }
        room.sessions.forEach { session ->
            session.sendSerialized(message.toResponse())
        }
    }

    /**
     * Close the web socket
     * Remove the session from the room
     * If the room become empty then remove the room from the [rooms]
     * */
    suspend fun disconnect(
        roomClientUserId: String,
        socketSession: WebSocketSession
    ) {
        socketSession.close(CloseReason(CloseReason.Codes.NORMAL, "Disconnected"))
        val room = rooms[roomClientUserId]
        requireNotNull(room) {
            "The room $roomClientUserId doesn't exist anymore, maybe it's removed"
        }
        val isRemoved = room.sessions.remove(socketSession)
        if (!isRemoved) throw IllegalStateException("The room connection has not been removed")
        if (room.sessions.isEmpty()) {
            rooms.remove(roomClientUserId)
        }
    }
}