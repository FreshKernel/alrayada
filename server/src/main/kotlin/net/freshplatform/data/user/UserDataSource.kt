package net.freshplatform.data.user

interface UserDataSource {
    suspend fun insertUser(user: User): Boolean
    suspend fun findUserByEmail(email: String): Result<User?>
    suspend fun findUserById(userId: String): Result<User?>
    suspend fun verifyEmail(email: String): Boolean
    suspend fun updateDeviceNotificationsToken(deviceNotificationsToken: UserDeviceNotificationsToken, userId: String): Boolean
    suspend fun deleteUserById(userId: String): Boolean
}