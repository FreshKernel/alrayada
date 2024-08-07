package net.freshplatform.data.user

import net.freshplatform.services.security.token_verification.TokenVerification

interface UserDataSource {
    suspend fun insertUser(user: User): Boolean
    suspend fun findUserByEmail(email: String): Result<User?>
    suspend fun isEmailUsed(email: String): Result<Boolean>
    suspend fun findUserById(userId: String): Result<User?>
    suspend fun findUserDeviceNotificationsTokenById(userId: String): Result<UserDeviceNotificationsToken?>
    suspend fun updateDeviceNotificationsTokenById(
        userId: String,
        deviceNotificationsToken: UserDeviceNotificationsToken
    ): Boolean

    suspend fun deleteUserById(userId: String): Boolean
    suspend fun updatePasswordById(userId: String, newPassword: String): Boolean
    suspend fun verifyUserEmailById(userId: String): Boolean
    suspend fun updateEmailVerificationStatusById(userId: String, emailVerification: TokenVerification): Boolean
    suspend fun updateResetPasswordVerificationStatusById(
        userId: String,
        resetPasswordVerification: TokenVerification
    ): Boolean

    /**
     * The main difference between [updatePasswordById] and [resetPasswordById] is
     * that [resetPasswordById] update the password and set the [User.resetPasswordVerification] to null
     * */
    suspend fun resetPasswordById(userId: String, newPassword: String): Boolean

    suspend fun updateUserInfoById(userId: String, userInfo: UserInfo): Boolean

    suspend fun updateUserPictureUrlById(userId: String, newPictureUrl: String): Boolean

    // For admin usage only functions:
    suspend fun setAccountActivatedById(userId: String, isAccountActivated: Boolean): Boolean

    suspend fun isAccountActivatedById(userId: String): Result<Boolean?>

    /**
     * @param search Filter the results using [UserInfo.labName]
     * @return the data sorted by [User.updatedAt]
     * */
    suspend fun getUsers(page: Int, limit: Int, search: String): Result<List<User>>
}