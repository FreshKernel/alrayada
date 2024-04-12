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
     * Get the last [ChatMessage] in a [LiveChatRoom] by [clientUserId]
     * */
    suspend fun getLastMessageInRoomByClientUserId(clientUserId: String): Result<ChatMessage?>

    /***
     * Get all [LiveChatRoom]
     * */
    suspend fun getAllRooms(page: Int, limit: Int): Result<List<LiveChatRoom>>

    /***
     * Get all [LiveChatRoom] by [clientUserId]
     * Sorted by [LiveChatRoom.updatedAt]
     * */
    suspend fun getAllMessagesByClientUserId(clientUserId: String, page: Int, limit: Int): Result<List<ChatMessage>>
}