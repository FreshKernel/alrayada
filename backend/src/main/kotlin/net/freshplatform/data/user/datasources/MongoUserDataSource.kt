package net.freshplatform.data.user.datasources

import net.freshplatform.data.user.User
import net.freshplatform.data.user.UserData
import net.freshplatform.data.user.UserDataSource
import net.freshplatform.data.user.UserDeviceNotificationsToken
import net.freshplatform.services.security.verification_token.TokenVerification
import com.mongodb.client.model.Filters
import org.litote.kmongo.*
import org.litote.kmongo.coroutine.CoroutineDatabase

class MongoUserDataSource(
    db: CoroutineDatabase
) : UserDataSource {
    private val users = db.getCollection<User>("users")
    override suspend fun getAllUsers(limit: Int, page: Int, searchQuery: String): List<User> {
        val skip = (page - 1) * limit
        val pattern = ".*$searchQuery.*".toRegex(RegexOption.IGNORE_CASE).toPattern()
        val filter = Filters.regex("${User::data.name}.${UserData::labName.name}", pattern)
        return (if (searchQuery.isBlank()) users.find() else users.find(filter))
            .descendingSort(User::createdAt)
            .skip(skip)
            .limit(limit)
            .toList()
    }

    override suspend fun getUserByEmail(email: String): User? {
        return users.findOne(User::email eq email.lowercase())
    }
    
    override suspend fun getUserByUUID(uuid: String): User? {
        return  users.findOne(User::uuid eq uuid)
    }

    override suspend fun insertUser(user: User): Boolean {
        return users.insertOne(user).wasAcknowledged()
    }

    override suspend fun deleteUserByUUID(userUUID: String): Boolean {
        return try {
            users.deleteOne(User::uuid eq userUUID).wasAcknowledged()
        } catch (e: Exception) {
            // probably IllegalArgumentException if MongodbId used
            false
        }
    }

    override suspend fun verifyEmail(email: String): Boolean {

        return users.updateOne(
            User::email eq email, combine(
                setValue(User::emailVerified, true),
                pullByFilter(
                    User::tokenVerifications,
                    TokenVerification::name eq User.Companion.TokenVerificationData.EmailVerification.NAME
                )
//                setValue(User::emailVerificationData, null)
            )
        )
            .wasAcknowledged()
    }

    override suspend fun updateEmailVerificationData(email: String, tokenVerification: TokenVerification): Boolean {
        val filter = User::email eq email
        val updateOne = users.updateOne(
            filter,
            pullByFilter(User::tokenVerifications, TokenVerification::name eq User.Companion.TokenVerificationData.EmailVerification.NAME)
        ).wasAcknowledged()
        val updateTwo = users.updateOne(
            filter,
            addToSet(User::tokenVerifications, tokenVerification)
        ).wasAcknowledged()
        return updateOne && updateTwo
    }

    override suspend fun updateForgotPasswordData(email: String, tokenVerification: TokenVerification): Boolean {
        val filter = User::email eq email
        val updateOne = users.updateOne(
            filter,
            pullByFilter(User::tokenVerifications, TokenVerification::name eq User.Companion.TokenVerificationData.ForgotPassword.NAME)
        ).wasAcknowledged()
        val updateTwo = users.updateOne(
            filter,
            addToSet(User::tokenVerifications, tokenVerification)
        ).wasAcknowledged()
        return updateOne && updateTwo
    }

    override suspend fun updateUserDataByUUID(userData: UserData, userUUID: String): Boolean {
        return try {
            users.updateOne(
                User::uuid eq userUUID,
                setValue(User::data, userData)
            ).wasAcknowledged()
        } catch (e: Exception) {
            false
        }
    }

    override suspend fun updateUserPasswordByUUID(newPassword: String, salt: String, userUUID: String): Boolean {
        return try {
            users.updateOne(
                User::uuid eq userUUID,
                combine(
                    setValue(User::password, newPassword),
                    setValue(User::salt, salt),
                    pullByFilter(
                        User::tokenVerifications,
                        TokenVerification::name eq User.Companion.TokenVerificationData.ForgotPassword.NAME
                    ),
                )
            ).wasAcknowledged()
        } catch (e: Exception) {
            false
        }
    }

    override suspend fun activateUserAccountByUUID(uuid: String): Boolean {
        return try {
            users.updateOne(
                User::uuid eq uuid,
                combine(
                    setValue(User::emailVerified, true),
                    setValue(User::accountActivated, true),
                    pullByFilter(
                        User::tokenVerifications,
                        TokenVerification::name eq User.Companion.TokenVerificationData.EmailVerification.NAME
                    ),
                )
            ).wasAcknowledged()
        } catch (e: Exception) {
            false
        }
    }

    override suspend fun deactivateUserAccountByUUID(uuid: String): Boolean {
        return try {
            users.updateOne(
                User::uuid eq uuid,
                setValue(User::accountActivated, false)
            ).wasAcknowledged()
        } catch (e: Exception) {
            false
        }
    }

    override suspend fun updateDeviceTokenByUUID(newDeviceToken: UserDeviceNotificationsToken, userUUID: String): Boolean {
        return try {
            users.updateOne(
                User::uuid eq userUUID,
                setValue(User::deviceNotificationsToken, newDeviceToken)
            ).wasAcknowledged()
        } catch (e: Exception) {
            false
        }
    }
}