package net.freshplatform.data.chat

import kotlinx.serialization.Serializable
import net.freshplatform.data.user.UserData
import net.freshplatform.utils.helpers.LocalDateTimeSerializer
import org.bson.codecs.pojo.annotations.BsonId
import org.bson.types.ObjectId
import java.time.LocalDateTime

data class ChatRoom(
    @BsonId
    val id: ObjectId = ObjectId(),
    val chatRoomId: String,
    val messages: List<ChatMessage> = emptyList(),
    val updatedAt: LocalDateTime
) {
    fun toResponse(userData: UserData) = ChatRoomResponse(
        id = id.toString(),
        chatRoomId = chatRoomId,
        updatedAt = updatedAt,
        userData = userData,
    )
}

@Serializable
data class ChatRoomResponse(
    val id: String,
    val chatRoomId: String,
    @Serializable(with = LocalDateTimeSerializer::class)
    val updatedAt: LocalDateTime,
    val userData: UserData
)

data class ChatMessage(
    @BsonId
    val id: ObjectId = ObjectId(),
    val text: String,
    val senderId: String,
    val createdAt: LocalDateTime = LocalDateTime.now()
) {
    fun toResponse() = ChatMessageResponse(
        id = id.toString(),
        text = text,
        senderId = senderId,
        createdAt = createdAt
    )
}

@Serializable
data class ChatMessageResponse(
    val id: String,
    val text: String,
    val senderId: String,
    @Serializable(with = LocalDateTimeSerializer::class)
    val createdAt: LocalDateTime
)
