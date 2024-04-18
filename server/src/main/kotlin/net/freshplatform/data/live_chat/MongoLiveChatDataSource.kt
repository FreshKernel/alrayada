package net.freshplatform.data.live_chat

import com.mongodb.client.model.*
import com.mongodb.kotlin.client.coroutine.MongoDatabase
import kotlinx.coroutines.flow.singleOrNull
import kotlinx.coroutines.flow.toList
import kotlinx.datetime.Clock
import org.bson.BsonDateTime
import org.bson.conversions.Bson
import org.bson.types.ObjectId

class MongoLiveChatDataSource(
    database: MongoDatabase
) : LiveChatDataSource {
    private val rooms = database.getCollection<LiveChatRoom>("liveChatRooms")

    override suspend fun insertMessage(roomClientUserId: String, message: ChatMessage): Boolean {
        return try {
            rooms.updateOne(
                Filters.eq(LiveChatRoom::roomClientUserId.name, roomClientUserId),
                Updates.combine(
                    Updates.setOnInsert(
                        LiveChatRoom::createdAt.name,
                        BsonDateTime(Clock.System.now().toEpochMilliseconds())
                    ),
                    setUpdatedAt(LiveChatRoom::updatedAt.name),
                    Updates.push(LiveChatRoom::messages.name, message),
                ),
                UpdateOptions().upsert(true)
            ).wasAcknowledged()
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }

    override suspend fun deleteRoomById(roomId: String): Boolean {
        return try {
            rooms.deleteOne(
                roomIdFilter(roomId)
            ).wasAcknowledged()
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }

    override suspend fun deleteAllRooms(): Boolean {
        return try {
            rooms.drop()
            true
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }

    override suspend fun getLastMessageInRoomByRoomClientUserId(roomClientUserId: String): Result<ChatMessage?> {
        return try {
            val projection = Projections.fields(
                Projections.include(LiveChatRoom::messages.name),
                Projections.slice(LiveChatRoom::messages.name, -1),
            )
            val message =
                rooms.find(roomClientUserIdFilter(roomClientUserId))
                    .projection(projection).singleOrNull()?.messages?.firstOrNull()
            Result.success(message)
        } catch (e: Exception) {
            e.printStackTrace()
            Result.failure(e)
        }
    }

    override suspend fun getRooms(page: Int, limit: Int): Result<List<LiveChatRoom>> {
        return try {
            val skip = (page - 1) * limit
            val rooms = rooms.find()
                .projection(Projections.exclude(LiveChatRoom::messages.name)) // Important for performance
                .sort(Sorts.descending(LiveChatRoom::updatedAt.name))
                .skip(skip)
                .limit(limit)
                .toList()
            Result.success(rooms)
        } catch (e: Exception) {
            e.printStackTrace()
            Result.failure(e)
        }
    }

    override suspend fun getMessagesByRoomClientUserId(roomClientUserId: String, page: Int, limit: Int): Result<List<ChatMessage>> {
        return try {
            val skip = (page - 1) * limit
            val messages = rooms.find(roomClientUserIdFilter(roomClientUserId))
                .sort(Sorts.descending("${LiveChatRoom::messages.name}.${ChatMessage::updatedAt.name}")) // TODO: The sorting is broken and doesn't work
                .projection(Projections.slice(LiveChatRoom::messages.name, skip, limit))
                .singleOrNull()?.messages ?: listOf()
            Result.success(messages)
        } catch (e: Exception) {
            e.printStackTrace()
            Result.failure(e)
        }
    }

    private fun roomIdFilter(roomId: String): Bson {
        return Filters.eq("_id", ObjectId(roomId))
    }

    private fun roomClientUserIdFilter(roomClientUserId: String): Bson {
        return Filters.eq(LiveChatRoom::roomClientUserId.name, roomClientUserId)
    }

    private fun setUpdatedAt(fieldName: String): Bson {
        return Updates.set(fieldName, BsonDateTime(Clock.System.now().toEpochMilliseconds()))
    }
}