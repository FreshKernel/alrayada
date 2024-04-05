package net.freshplatform.data.user

import com.mongodb.client.model.Filters
import com.mongodb.client.model.Projections
import com.mongodb.client.model.Sorts
import com.mongodb.client.model.Updates
import com.mongodb.kotlin.client.coroutine.MongoDatabase
import kotlinx.coroutines.flow.singleOrNull
import kotlinx.coroutines.flow.toList
import kotlinx.datetime.Clock
import net.freshplatform.services.security.token_verification.TokenVerification
import org.bson.BsonDateTime
import org.bson.Document
import org.bson.conversions.Bson
import org.bson.types.ObjectId

class MongoUserDataSource(
    database: MongoDatabase
) : UserDataSource {
    private val users = database.getCollection<User>("users")
    override suspend fun insertUser(user: User): Boolean {
        return try {
            users.insertOne(user).wasAcknowledged()
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }

    override suspend fun findUserByEmail(email: String): Result<User?> {
        return try {
            Result.success(
                users.find(Filters.eq(User::email.name, email))
                    .singleOrNull()
            )
        } catch (e: Exception) {
            e.printStackTrace()
            Result.failure(e)
        }
    }

    override suspend fun isEmailUsed(email: String): Result<Boolean> {
        return try {
            Result.success(
                users.countDocuments(Filters.eq(User::email.name, email))
                        > 0
            )
        } catch (e: Exception) {
            e.printStackTrace()
            Result.failure(e)
        }
    }

    override suspend fun findUserById(userId: String): Result<User?> {
        return try {
            Result.success(
                users.find(
                    userIdFilter(userId)
                )
                    .singleOrNull()
            )
        } catch (e: Exception) {
            e.printStackTrace()
            Result.failure(e)
        }
    }

    override suspend fun verifyUserEmailById(userId: String): Boolean {
        return try {
            users.updateOne(
                userIdFilter(userId),
                Updates.combine(
                    Updates.set(User::isEmailVerified.name, true),
                    Updates.set(User::emailVerification.name, null),
                    generateUpdatedAtUpdate()
                )
            ).wasAcknowledged()
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }

    override suspend fun updateEmailVerificationStatusById(
        userId: String,
        emailVerification: TokenVerification
    ): Boolean {
        return try {
            users.updateOne(
                userIdFilter(userId),
                Updates.combine(
                    Updates.set(User::emailVerification.name, emailVerification),
                    generateUpdatedAtUpdate()
                )
            ).wasAcknowledged()
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }

    override suspend fun updateResetPasswordVerificationStatusById(
        userId: String,
        resetPasswordVerification: TokenVerification
    ): Boolean {
        return try {
            users.updateOne(
                userIdFilter(userId),
                Updates.combine(
                    Updates.set(User::resetPasswordVerification.name, resetPasswordVerification),
                    generateUpdatedAtUpdate()
                )
            ).wasAcknowledged()
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }

    override suspend fun resetPasswordById(userId: String, newPassword: String): Boolean {
        return try {
            users.updateOne(
                userIdFilter(userId),
                Updates.combine(
                    Updates.set(User::password.name, newPassword),
                    Updates.set(User::resetPasswordVerification.name, null),
                    generateUpdatedAtUpdate()
                )
            ).wasAcknowledged()
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }

    override suspend fun updateUserInfoById(userId: String, userInfo: UserInfo): Boolean {
        return try {
            users.updateOne(
                userIdFilter(userId),
                Updates.combine(
                    Updates.set(User::info.name, userInfo),
                    generateUpdatedAtUpdate()
                )
            ).wasAcknowledged()
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }

    override suspend fun updateUserPictureUrlById(userId: String, newPictureUrl: String): Boolean {
        return try {
            users.updateOne(
                userIdFilter(userId),
                Updates.combine(
                    Updates.set(User::pictureUrl.name, newPictureUrl),
                    generateUpdatedAtUpdate()
                )
            ).wasAcknowledged()
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }

    override suspend fun setAccountActivatedById(userId: String, isAccountActivated: Boolean): Boolean {
        return try {
            users.updateOne(
                userIdFilter(userId),
                Updates.combine(
                    Updates.set(User::isAccountActivated.name, isAccountActivated),
                    generateUpdatedAtUpdate()
                )
            ).wasAcknowledged()
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }

    override suspend fun isAccountActivatedById(userId: String): Result<Boolean?> {
        return try {
            val projection = Projections.include(User::isAccountActivated.name)
            val result = users.find<Document>(userIdFilter(userId)).projection(projection).singleOrNull()
                ?.getBoolean(User::isAccountActivated.name)
            Result.success(result)
        } catch (e: Exception) {
            e.printStackTrace()
            Result.failure(e)
        }
    }

    override suspend fun getAllUsers(page: Int, limit: Int, searchQuery: String): Result<List<User>> {
        return try {
            val skip = (page - 1) * limit
            val pattern = ".*$searchQuery.*".toRegex(RegexOption.IGNORE_CASE).toPattern()
            val filter = Filters.regex("${User::info.name}.${UserInfo::labName.name}", pattern)
            val users = (if (searchQuery.isBlank()) users.find() else users.find(filter))
                .sort(Sorts.descending(User::updatedAt.name))
                .skip(skip)
                .limit(limit)
                .toList()
            Result.success(users)
        } catch (e: Exception) {
            e.printStackTrace()
            Result.failure(e)
        }
    }

    override suspend fun updateDeviceNotificationsTokenById(
        userId: String,
        deviceNotificationsToken: UserDeviceNotificationsToken
    ): Boolean {
        return try {
            users.updateOne(
                userIdFilter(userId),
                Updates.combine(
                    Updates.set(User::deviceNotificationsToken.name, deviceNotificationsToken),
                    generateUpdatedAtUpdate()
                )
            ).wasAcknowledged()
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }

    override suspend fun deleteUserById(userId: String): Boolean {
        return try {
            users.deleteOne(
                userIdFilter(userId),
            ).wasAcknowledged()
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }

    override suspend fun updatePasswordById(userId: String, newPassword: String): Boolean {
        return try {
            users.updateOne(
                userIdFilter(userId),
                Updates.combine(
                    Updates.set(User::password.name, newPassword),
                    generateUpdatedAtUpdate()
                )
            ).wasAcknowledged()
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }

    private fun userIdFilter(userId: String): Bson {
        return Filters.eq("_id", ObjectId(userId))
    }

    private fun generateUpdatedAtUpdate(): Bson {
        return Updates.set(User::updatedAt.name, BsonDateTime(Clock.System.now().toEpochMilliseconds()))
    }
}