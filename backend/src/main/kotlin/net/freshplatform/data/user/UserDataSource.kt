package net.freshplatform.data.user

import net.freshplatform.services.security.verification_token.TokenVerification

interface UserDataSource {
    suspend fun getAllUsers(limit: Int = 10, page: Int = 1, searchQuery: String = ""): List<User>
    suspend fun getUserByEmail(email: String): User?
    suspend fun getUserByUUID(uuid: String): User?
    suspend fun insertUser(user: User): Boolean
    suspend fun deleteUserByUUID(userUUID: String): Boolean
    suspend fun verifyEmail(email: String): Boolean
    suspend fun updateEmailVerificationData(email: String, tokenVerification: TokenVerification): Boolean
    suspend fun updateForgotPasswordData(email: String, tokenVerification: TokenVerification): Boolean
    suspend fun updateUserDataByUUID(userData: UserData, userUUID: String): Boolean
    suspend fun updateUserPasswordByUUID(newPassword: String, salt: String, userUUID: String): Boolean
    suspend fun activateUserAccountByUUID(uuid: String): Boolean
    suspend fun deactivateUserAccountByUUID(uuid: String): Boolean
    suspend fun updateDeviceTokenByUUID(newDeviceToken: UserDeviceNotificationsToken, userUUID: String): Boolean
}