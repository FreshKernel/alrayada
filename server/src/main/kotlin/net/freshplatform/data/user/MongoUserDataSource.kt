package net.freshplatform.data.user

import com.mongodb.client.model.Filters
import com.mongodb.client.model.Updates
import com.mongodb.kotlin.client.coroutine.MongoDatabase
import kotlinx.coroutines.flow.singleOrNull
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

    override suspend fun findUserByEmail(email: String): User? {
        return try {
            users.find(Filters.eq(User::email.name, email))
                .singleOrNull()
        } catch (e: Exception) {
            e.printStackTrace()
            null
        }
    }

    override suspend fun findUserById(userId: String): User? {
        return try {
            users.find(
                Filters.eq("_id", ObjectId(userId))
            )
                .singleOrNull()
        } catch (e: Exception) {
            e.printStackTrace()
            null
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

    override suspend fun updateDeviceNotificationsToken(
        deviceNotificationsToken: UserDeviceNotificationsToken,
        userId: String
    ): Boolean {
        return try {
            users.updateOne(
                Filters.eq(User::id.name, userId),
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
                Filters.eq(User::id.name, userId),
            ).wasAcknowledged()
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }
}