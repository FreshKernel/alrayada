package net.freshplatform.routes.chat

import net.freshplatform.data.chat.ChatDataSource
import net.freshplatform.data.chat.ChatMessage
import net.freshplatform.data.chat.ChatMessageResponse
import net.freshplatform.data.user.UserDataSource
import net.freshplatform.services.notifications.NotificationService
import net.freshplatform.services.telegram.TelegramBotService
import io.ktor.websocket.*
import kotlinx.serialization.builtins.ListSerializer
import kotlinx.serialization.json.Json
import java.time.Duration
import java.time.LocalDateTime
import java.util.concurrent.ConcurrentHashMap

data class ChatRoom(val members: MutableList<WebSocketSession>)

class ChatRoomController(
    private val chatDataSource: ChatDataSource,
    private val userDataSource: UserDataSource,
    private val notificationService: NotificationService,
    private val telegramBotService: TelegramBotService,
) {
    val chatRooms = ConcurrentHashMap<String, ChatRoom>()

    /**
     * Load all the previous messages in the chat and send it to the connector
     * */
    suspend fun loadPreviousMessages(
        chatRoomId: String,
        socketSession: WebSocketSession
    ) = chatDataSource.getAllByRoomId(chatRoomId)
        .map { it.toResponse() }.also {
            if (it.isEmpty()) return@also
            val json = Json.encodeToString(ListSerializer(ChatMessageResponse.serializer()), it)
            socketSession.send(json)
        }

    /**
     * if chat room doesn't exist then create it
     * and add the socket session, and if exists
     * just add the socket session of the client
     *  */
    fun onJoin(
        chatRoomId: String,
        socketSession: WebSocketSession
    ) {
        if (!chatRooms.containsKey(chatRoomId)) {
            chatRooms[chatRoomId] = ChatRoom(
                members = mutableListOf(socketSession)
            )
            return
        }
        chatRooms[chatRoomId]!!.members.add(socketSession)
    }

    /**
     * Insert the message in the database
     * then send it to all members that are connected
     * */
    suspend fun sendMessage(
        chatRoomId: String,
        senderId: String,
        text: String
    ) {
        val message = ChatMessage(
            text = text,
            senderId = senderId,
        )
        chatDataSource.insertToRoom(
            chatRoomId,
            message
        )
        // Don't worry, this will not be null
        chatRooms[chatRoomId]!!.members.forEach { webSocketSession ->

            val jsonStringMsg = Json.encodeToString(
                ChatMessageResponse.serializer(),
                message.toResponse()
            )
            webSocketSession.send(jsonStringMsg)
        }

        // send notifications for admin and user
        chatDataSource.getLastOneInRoomId(chatRoomId)?.let {
            val now = LocalDateTime.now()
            val duration = Duration.between(it.createdAt, now)
            val isAnMinuteAgoOrMore = duration.toMinutes() >= 1
            val user = userDataSource.getUserByUUID(chatRoomId)
            if (isAnMinuteAgoOrMore) {
                if (senderId != chatRoomId) {
                    // User
                    user?.let { notNullUser ->
                        notificationService.sendToDevice(
                            title = "A new message from the admin!",
                            body = text,
                            deviceToken = notNullUser.deviceNotificationsToken
                        )
                    }
                    return@let
                }
                // Admin
                telegramBotService.sendMessage("A new message from '${user?.data?.labOwnerName}'\nmessage: <b>$text</b>")
            }
        }

    }

    /**
     * First of all, close the web socket connection
     * Second check if the room is exists and remove the socket
     * Third check if there are no sockets so the chat members is empty
     * then remove it from the chat rooms
     * */
    suspend fun tryDisconnect(
        chatRoomId: String,
        socketSession: WebSocketSession
    ) {
        socketSession.close()
        val chatRoom = chatRooms[chatRoomId] ?: return
        chatRoom.members.remove(socketSession)
        if (chatRoom.members.isEmpty()) {
            chatRooms.remove(chatRoomId)
        }
    }
}