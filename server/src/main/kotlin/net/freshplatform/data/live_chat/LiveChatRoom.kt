package net.freshplatform.data.live_chat

import kotlinx.datetime.Instant
import kotlinx.serialization.Contextual
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import net.freshplatform.utils.InstantAsBsonDateTime
import org.bson.types.ObjectId

@Serializable
data class LiveChatRoom(
    @SerialName("_id")
    @Contextual
    val id: ObjectId = ObjectId(), // The room id
    /**
     * The [roomClientUserId] is for the client or the creator of this room
     * The reason why this is not roomId, so it doesn't conflict with [LiveChatRoom.id]
     * */
    val roomClientUserId: String,
    // Default empty list required in case off loading the rooms without including the messages (getAllRooms)
    val messages: List<ChatMessage> = emptyList(),
    @Serializable(with = InstantAsBsonDateTime::class)
    val createdAt: Instant,
    @Serializable(with = InstantAsBsonDateTime::class)
    val updatedAt: Instant
) {
    fun toResponse() = LiveChatRoomResponse(
        id = id.toString(),
        roomClientUserId = roomClientUserId,
        createdAt = createdAt,
        updatedAt = updatedAt,
    )
}

@Serializable
data class LiveChatRoomResponse(
    val id: String,
    val roomClientUserId: String,
    val createdAt: Instant,
    val updatedAt: Instant
)