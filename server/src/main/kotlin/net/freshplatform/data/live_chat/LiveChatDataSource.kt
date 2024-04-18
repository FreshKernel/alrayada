package net.freshplatform.data.live_chat

interface LiveChatDataSource {
    /**
     * Insert a [message] to a [LiveChatRoom] by [roomClientUserId]
     * create the room if it doesn't exist
     * otherwise just insert the [message]
     * */
    suspend fun insertMessage(roomClientUserId: String, message: ChatMessage): Boolean

    /**
     * Delete a [LiveChatRoom] by [roomId]
     * */
    suspend fun deleteRoomById(roomId: String): Boolean

    suspend fun deleteAllRooms(): Boolean

    /**
     * Get the last [ChatMessage] in a [LiveChatRoom] by [roomClientUserId]
     * */
    suspend fun getLastMessageInRoomByRoomClientUserId(roomClientUserId: String): Result<ChatMessage?>

    /***
     * Get all [LiveChatRoom]
     * */
    suspend fun getRooms(page: Int, limit: Int): Result<List<LiveChatRoom>>

    /***
     * Get all [LiveChatRoom] by [roomClientUserId]
     * Sorted by [LiveChatRoom.updatedAt]
     * */
    suspend fun getMessagesByRoomClientUserId(roomClientUserId: String, page: Int, limit: Int): Result<List<ChatMessage>>
}