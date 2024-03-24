package net.freshplatform.data.user

import net.freshplatform.services.security.token_verification.TokenVerification

interface UserDataSource {
    suspend fun insertUser(user: User): Boolean
    suspend fun findUserByEmail(email: String): Result<User?>
    suspend fun isEmailUsed(email: String): Result<Boolean>
    suspend fun findUserById(userId: String): Result<User?>
    suspend fun updateDeviceNotificationsTokenById(
        userId: String,
        deviceNotificationsToken: UserDeviceNotificationsToken
    ): Boolean

    suspend fun deleteUserById(userId: String): Boolean
    suspend fun updatePasswordById(userId: String, newPassword: String): Boolean
    suspend fun verifyEmail(email: String): Boolean
    suspend fun updateEmailVerificationStatusById(userId: String, emailVerification: TokenVerification): Boolean
    suspend fun updateResetPasswordVerificationStatusById(
        userId: String,
        resetPasswordVerification: TokenVerification
    ): Boolean

    /**
     * The main difference between [updatePasswordById] and [resetPasswordById] is
     * that [resetPasswordById] update the password and set the reset password verification to null
     * */
    suspend fun resetPasswordById(userId: String, newPassword: String): Boolean

    suspend fun updateUserInfoById(userId: String, userInfo: UserInfo): Boolean

    // For admin usage only functions:
    suspend fun setAccountActivatedById(userId: String, isAccountActivated: Boolean): Boolean

    suspend fun isAccountActivatedById(userId: String): Result<Boolean?>

    /**
     * The [searchQuery] filter the results using [UserInfo.labName]
     * */
    suspend fun getAllUsers(page: Int, limit: Int, searchQuery: String = ""): Result<List<User>>
}