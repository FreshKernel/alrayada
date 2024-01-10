package net.freshplatform.data.chat.datasources

import net.freshplatform.data.chat.ChatDataSource
import net.freshplatform.data.chat.ChatMessage
import net.freshplatform.data.chat.ChatRoom
import com.mongodb.client.model.Updates
import org.litote.kmongo.*
import org.litote.kmongo.coroutine.CoroutineDatabase
import java.time.LocalDateTime

class MongoChatDataSource(
    db: CoroutineDatabase
) : ChatDataSource {
    private val messages = db.getCollection<ChatRoom>("chats")

    override suspend fun getAllByRoomId(chatRoomId: String, limit: Int, page: Int): List<ChatMessage> {
        return messages.findOne(ChatRoom::chatRoomId eq chatRoomId)
            ?.messages ?: emptyList()
    }

    override suspend fun getLastOneInRoomId(chatRoomId: String): ChatMessage? {
        val messages = messages.findOne(ChatRoom::chatRoomId eq chatRoomId)?.messages ?: return null
        if (messages.isEmpty()) return null
        return try {
            messages.let {
                it[it.lastIndex - 1]
            }
        } catch (e: IndexOutOfBoundsException) {
            null
        }
    }

    override suspend fun getAllRooms(limit: Int, page: Int): List<ChatRoom> {
        return messages.find()
            .projection(
                exclude(ChatRoom::messages)
            )
            .descendingSort(ChatRoom::updatedAt)
            .toList()
    }

    override suspend fun deleteRoom(chatRoomId: String): Boolean {
        return try {
            messages.deleteOne(
                ChatRoom::chatRoomId eq chatRoomId
            ).wasAcknowledged()
        } catch (e: Exception) {
            false
        }
    }

    override suspend fun insertToRoom(chatRoomId: String, message: ChatMessage): Boolean {
        return messages.updateOne(
            filter = ChatRoom::chatRoomId eq chatRoomId,
            update = combine(
                Updates.push(ChatRoom::messages.name, message),
                setValue(ChatRoom::updatedAt, LocalDateTime.now())
            ),
            upsert()
        ).wasAcknowledged()
    }
}