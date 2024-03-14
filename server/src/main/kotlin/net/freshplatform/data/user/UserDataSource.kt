package net.freshplatform.data.user

interface UserDataSource {
    suspend fun insertUser(user: User): Boolean
    suspend fun findUserByEmail(email: String): Result<User?>
    suspend fun findUserById(userId: String): Result<User?>
    suspend fun updateDeviceNotificationsTokenById(userId: String, deviceNotificationsToken: UserDeviceNotificationsToken): Boolean
    suspend fun deleteUserById(userId: String): Boolean
    suspend fun updateUserPasswordById(userId: String, newPassword: String): Boolean
    suspend fun verifyEmail(email: String): Boolean
}