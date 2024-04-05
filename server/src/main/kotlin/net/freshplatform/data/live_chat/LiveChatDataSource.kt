package net.freshplatform.data.live_chat

interface LiveChatDataSource {
    /**
     * Insert a [message] to a [LiveChatRoom] by [clientUserId]
     * create the room if it doesn't exist
     * otherwise just insert the [message]
     * */
    suspend fun insertMessage(clientUserId: String, message: ChatMessage): Boolean

    /**
     * Delete a [LiveChatRoom] by [roomId]
     * */
    suspend fun deleteRoomById(roomId: String): Boolean

    /**
     * Get the last [ChatMessage] in a [LiveChatRoom] by [userId]
     * */
    suspend fun getLastMessageInRoomById(userId: String): Result<ChatMessage?>

    /***
     * Get all [LiveChatRoom]
     * */
    suspend fun getAllRooms(page: Int, limit: Int): Result<List<LiveChatRoom>>

    /***
     * Get all [LiveChatRoom] by [userId]
     * Sort by [LiveChatRoom.updatedAt]
     * */
    suspend fun getAllMessagesByUserId(userId: String, page: Int, limit: Int): Result<List<ChatMessage>>
}