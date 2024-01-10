package net.freshplatform.data.chat

interface ChatDataSource {
    suspend fun getAllByRoomId(chatRoomId: String, limit: Int = 10, page: Int = 1): List<ChatMessage>
    suspend fun getLastOneInRoomId(chatRoomId: String): ChatMessage?
    suspend fun getAllRooms(limit: Int = 10, page: Int = 1): List<ChatRoom>
    suspend fun deleteRoom(chatRoomId: String): Boolean
    suspend fun insertToRoom(chatRoomId: String, message: ChatMessage): Boolean
}