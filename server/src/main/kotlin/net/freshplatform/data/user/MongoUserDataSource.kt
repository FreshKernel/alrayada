package net.freshplatform.data.user

import com.mongodb.client.model.Filters
import com.mongodb.client.model.Updates
import com.mongodb.kotlin.client.coroutine.MongoDatabase
import kotlinx.coroutines.flow.singleOrNull
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

    override suspend fun verifyEmail(email: String): Boolean {
        return try {
            users.updateOne(
                Filters.eq(User::email.name, email),
                Updates.combine(
                    Updates.set(User::isEmailVerified.name, true),
                    Updates.set(User::emailVerification.name, null)
                )
            ).wasAcknowledged()
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }

    override suspend fun updateDeviceNotificationsTokenById(
        userId: String,
        deviceNotificationsToken: UserDeviceNotificationsToken
    ): Boolean {
        return try {
            users.updateOne(
                userIdFilter(userId),
                Updates.set(
                    User::deviceNotificationsToken.name,
                    deviceNotificationsToken
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

    override suspend fun updateUserPasswordById(userId: String, newPassword: String): Boolean {
        return try {
            users.updateOne(
                userIdFilter(userId),
                Updates.set(
                    User::password.name,
                    newPassword
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
}