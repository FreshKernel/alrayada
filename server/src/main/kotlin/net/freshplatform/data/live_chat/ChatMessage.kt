package net.freshplatform.data.live_chat

import kotlinx.datetime.Instant
import kotlinx.serialization.Contextual
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import net.freshplatform.utils.serialization.InstantAsBsonDateTime
import org.bson.types.ObjectId

@Serializable
data class ChatMessage(
    @SerialName("_id")
    @Contextual
    val id: ObjectId = ObjectId(),
    val text: String,
    val senderId: String,
    @Serializable(with = InstantAsBsonDateTime::class)
    val createdAt: Instant,
    @Serializable(with = InstantAsBsonDateTime::class)
    val updatedAt: Instant,
) {
    fun toResponse() = ChatMessageResponse(
        id = id.toString(),
        text = text,
        senderId = senderId,
        createdAt = createdAt,
        updatedAt = updatedAt,
    )
}

@Serializable
data class ChatMessageResponse(
    val id: String,
    val text: String,
    val senderId: String,
    val createdAt: Instant,
    val updatedAt: Instant
)