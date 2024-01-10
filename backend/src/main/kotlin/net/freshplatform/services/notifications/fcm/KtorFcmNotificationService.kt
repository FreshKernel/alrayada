package net.freshplatform.services.notifications.fcm

import net.freshplatform.data.user.UserDeviceNotificationsToken
import net.freshplatform.services.http_client.HttpService
import net.freshplatform.services.notifications.*
import net.freshplatform.utils.constants.Constants
import com.google.auth.oauth2.GoogleCredentials
import io.ktor.client.*
import io.ktor.client.call.*
import io.ktor.client.plugins.*
import io.ktor.client.request.*
import io.ktor.http.*
import kotlinx.serialization.Serializable
import java.io.FileNotFoundException
import java.io.IOException
import java.io.InputStream


/**
 * Push notification using fcm by rest api using ktor client
 * */
class KtorFcmNotificationService(
    private val client: HttpClient = HttpService.client
) : NotificationService {

    companion object {
        private const val URL = "https://fcm.googleapis.com/v1/projects/${Constants.FIREBASE_PROJECT_ID}/messages:send"

        @Serializable
        private data class FcmNotificationResponse(
            val name: String
        )
    }

    private val serviceAccount: InputStream =
        Thread.currentThread().contextClassLoader.getResourceAsStream("firebaseServiceAccountKey.json")
            ?: throw FileNotFoundException("firebaseServiceAccountKey.json is required and should be placed in the resources of the server")
    private val credentials: GoogleCredentials? = GoogleCredentials.fromStream(serviceAccount)
        .createScoped(listOf("https://www.googleapis.com/auth/firebase.messaging"))

    private fun fcmAccessToken(): String? {
        return try {
            if (credentials == null) {
                println("Unexpected error!, val credentials: GoogleCredentials? is null")
                return null
            }
            credentials.refreshIfExpired()
//            credentials?.refreshAccessToken()
            if (credentials.accessToken?.tokenValue != null) {
                return credentials.accessToken.tokenValue
            }
            null
        } catch (e: IOException) {
            println("Error while refresh the token, please check the firebase credentials")
            e.printStackTrace()
            null
        } catch (e: Exception) {
            e.printStackTrace()
            null
        }
    }

    override suspend fun sendToDevice(
        title: String,
        body: String,
        deviceToken: UserDeviceNotificationsToken,
        data: Map<String, String>?
    ): String? {
        if (deviceToken.firebase.isBlank()) throw NotificationsServiceDeviceTokenEmptyException("FcmToken is empty")
        return try {
            val message = Notification(
                message = NotificationMessage(
                    token = deviceToken.firebase,
                    notification = AppNotification(
                        title, body
                    ),
                    data = data
                )
            )
            val response = client.post(URL) {
                contentType(ContentType.Application.Json)
                setBody(message)
                header(HttpHeaders.Authorization, "Bearer ${fcmAccessToken()}")
            }
            val responseBody = response.body<FcmNotificationResponse>()
            responseBody.name
        } catch (e: ResponseException) {
            println("Error: ${e.localizedMessage}")
            e.printStackTrace()
            null
        } catch (e: Exception) {
            null
        }
    }
}