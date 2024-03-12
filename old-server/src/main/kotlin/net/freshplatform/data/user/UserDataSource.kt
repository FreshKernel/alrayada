package net.freshplatform.data.user

import net.freshplatform.services.security.verification_token.TokenVerification

interface UserDataSource {
    suspend fun getAllUsers(limit: Int = 10, page: Int = 1, searchQuery: String = ""): List<User>
    suspend fun getUserByEmail(email: String): User?
    suspend fun getUserByUUID(uuid: String): User?
    suspend fun insertUser(user: User): Boolean
    suspend fun deleteUserById(userId: String): Boolean
    suspend fun verifyEmail(email: String): Boolean
    suspend fun updateEmailVerificationData(email: String, tokenVerification: TokenVerification): Boolean
    suspend fun updateForgotPasswordData(email: String, tokenVerification: TokenVerification): Boolean
    suspend fun updateUserDataById(userData: UserData, userUUID: String): Boolean
    suspend fun updateUserPasswordById(newPassword: String, salt: String, userId: String): Boolean
    suspend fun activateUserAccountById(userId: String): Boolean
    suspend fun deactivateUserAccountById(userId: String): Boolean
    suspend fun updateDeviceTokenById(newDeviceToken: UserDeviceNotificationsToken, userId: String): Boolean
}