package net.freshplatform.services.notifications.one_signal

import net.freshplatform.data.user.UserDeviceNotificationsToken
import net.freshplatform.services.http_client.HttpService
import net.freshplatform.services.notifications.NotificationService
import net.freshplatform.services.notifications.NotificationsServiceDeviceTokenEmptyException
import net.freshplatform.services.secret_variables.SecretVariablesName
import net.freshplatform.services.secret_variables.SecretVariablesService
import net.freshplatform.utils.extensions.getFileFromUserWorkingDirectory
import io.ktor.client.*
import io.ktor.client.call.*
import io.ktor.client.plugins.*
import io.ktor.client.request.*
import io.ktor.http.*
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

class KtorOneSignalNotificationService(
    private val httpClient: HttpClient = HttpService.client
) : NotificationService {

    companion object {
        private const val URL = "https://onesignal.com/api/v1/notifications"
//        private val playerIDRegex = Regex("[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}")

        @Serializable
        private data class OneSignalNotificationResponse(
            val id: String? = null,
            @SerialName("external_id")
            val externalId: String? = null,
            val errors: List<String>? = null
        )

        @Serializable
        private data class OneSignalNotificationContent(
            val en: String
        )

        @Serializable
        private data class OneSignalNotificationRequest(
            val contents: OneSignalNotificationContent,
            val headings: OneSignalNotificationContent,
            @SerialName("app_id")
            val appId: String,
            @SerialName("include_subscription_ids")
            val includeSubscriptionIds: List<String>,
            val data: Map<String, String>?
        )
    }

    private val oneSignalAppId = SecretVariablesService.require(SecretVariablesName.OneSignalAppId)
    private val oneSignalRestApiKey = SecretVariablesService.require(SecretVariablesName.OneSignalRestApiKey)

    override suspend fun sendToDevice(
        title: String,
        body: String,
        deviceToken: UserDeviceNotificationsToken,
        data: Map<String, String>?
    ): String? {
        val deviceTokenString = deviceToken.oneSignal
        if (deviceTokenString.isBlank()) throw NotificationsServiceDeviceTokenEmptyException("OneSignalPlayerId is empty")
//        if (!playerIDRegex.matches(deviceTokenString)) throw NotificationServiceDeviceTokenNotValidException()
        return try {
            val response = httpClient.post(URL) {
                header(HttpHeaders.Authorization, "Basic $oneSignalRestApiKey")
                contentType(ContentType.Application.Json)
                setBody(
                    OneSignalNotificationRequest(
                        contents = OneSignalNotificationContent(
                            en = body
                        ),
                        headings = OneSignalNotificationContent(
                            en = title
                        ),
                        includeSubscriptionIds = listOf(deviceTokenString),
                        appId = oneSignalAppId,
                        data = data
                    )
                )
            }
            val responseJson = response.body<OneSignalNotificationResponse>()
            return responseJson.id
        } catch (e: ResponseException) {
            // TODO: Log error
            null
        } catch (e: Exception) {
            // TODO: Log error
            null
        }
    }
}