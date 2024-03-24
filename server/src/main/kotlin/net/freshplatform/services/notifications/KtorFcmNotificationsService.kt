package net.freshplatform.services.notifications

import com.google.auth.oauth2.GoogleCredentials
import io.ktor.client.*
import io.ktor.client.call.*
import io.ktor.client.plugins.*
import io.ktor.client.request.*
import io.ktor.http.*
import io.ktor.utils.io.errors.*
import kotlinx.serialization.Serializable
import net.freshplatform.data.user.UserDeviceNotificationsToken
import net.freshplatform.utils.getEnvironmentVariables
import java.io.ByteArrayInputStream
import java.io.InputStream

class KtorFcmNotificationsService(
    private val client: HttpClient
) : NotificationsService {
    private companion object {
        private val URL =
            "https://fcm.googleapis.com/v1/projects/${getEnvironmentVariables().firebaseProjectId}/messages:send"

        @Serializable
        data class FcmNotification(
            val message: NotificationMessage
        )

        @Serializable
        data class NotificationMessage(
            val token: String? = null,
            val topic: String? = null,
            val notification: NotificationContent? = null,
            val data: Map<String, String>? = null
        )

        @Serializable
        data class NotificationContent(
            val title: String? = null,
            val body: String? = null
        )

        @Serializable
        data class FcmNotificationResponse(
            val name: String
        )
    }

    private val inputStream: InputStream = ByteArrayInputStream(getEnvironmentVariables().firebaseProjectServiceAccountKey.toByteArray())
    private val credentials: GoogleCredentials? = GoogleCredentials.fromStream(inputStream)
        .createScoped(listOf("https://www.googleapis.com/auth/firebase.messaging"))

    private fun fcmAccessToken(): Result<String> {
        return try {
            if (credentials == null) {
                throw IllegalArgumentException("GoogleCredentials should not be null, please check firebase project service account key")
            }
            credentials.refreshIfExpired()
//            credentials.refreshAccessToken()
            Result.success(credentials.accessToken.tokenValue)
        } catch (e: java.io.IOException) {
            e.printStackTrace()
            Result.failure(e)
        } catch (e: Exception) {
            e.printStackTrace()
            Result.failure(e)
        }
    }

    override suspend fun sendToDevice(
        title: String,
        body: String,
        deviceNotificationsToken: UserDeviceNotificationsToken,
        data: Map<String, String>?
    ): Result<String> {
        return try {
            val message = FcmNotification(
                message = NotificationMessage(
                    token = deviceNotificationsToken.firebase,
                    notification = NotificationContent(title, body),
                    data = data
                )
            )
            val response = client.post(URL) {
                contentType(ContentType.Application.Json)
                setBody(message)
                header(HttpHeaders.Authorization, "Bearer ${fcmAccessToken().getOrThrow()}")
            }
            val responseBody = response.body<FcmNotificationResponse>()
            Result.success(responseBody.name)
        } catch (e: IOException) {
            e.printStackTrace()
            Result.failure(e)
        } catch (e: ResponseException) {
            e.printStackTrace()
            Result.failure(e)
        } catch (e: Exception) {
            e.printStackTrace()
            Result.failure(e)
        }
    }
}