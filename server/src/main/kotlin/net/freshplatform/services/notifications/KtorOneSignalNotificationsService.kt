package net.freshplatform.services.notifications

//import io.ktor.client.*
//import io.ktor.client.call.*
//import io.ktor.client.plugins.*
//import io.ktor.client.request.*
//import io.ktor.http.*
//import kotlinx.serialization.SerialName
//import kotlinx.serialization.Serializable
//import net.freshplatform.data.user.UserDeviceNotificationsToken
//import net.freshplatform.utils.getEnvironmentVariables
//
//class KtorOneSignalNotificationsService(
//    private val client: HttpClient
//): NotificationsService {
//
//    companion object {
//        private const val URL = "https://onesignal.com/api/v1/notifications"
//
//        @Serializable
//        private data class OneSignalNotificationResponse(
//            val id: String? = null,
//            @SerialName("external_id")
//            val externalId: String? = null,
//            val errors: List<String>? = null
//        )
//
//        @Serializable
//        private data class OneSignalNotificationContent(
//            val en: String
//        )
//
//        @Serializable
//        private data class OneSignalNotificationRequest(
//            val contents: OneSignalNotificationContent,
//            val headings: OneSignalNotificationContent,
//            @SerialName("app_id")
//            val appId: String,
//            @SerialName("include_subscription_ids")
//            val includeSubscriptionIds: List<String>,
//            val data: Map<String, String>?
//        )
//    }
//    override suspend fun sendToDevice(
//        title: String,
//        body: String,
//        deviceNotificationsToken: UserDeviceNotificationsToken,
//        data: Map<String, String>?
//    ): Result<String> {
//        return try {
//            val response = client.post(URL) {
//                header(HttpHeaders.Authorization, "Basic ${getEnvironmentVariables().oneSignalRestApiKey}")
//                contentType(ContentType.Application.Json)
//                setBody(
//                    OneSignalNotificationRequest(
//                        contents = OneSignalNotificationContent(
//                            en = body
//                        ),
//                        headings = OneSignalNotificationContent(
//                            en = title
//                        ),
//                        includeSubscriptionIds = listOf(deviceNotificationsToken.oneSignal),
//                        appId = getEnvironmentVariables().oneSignalAppId,
//                        data = data
//                    )
//                )
//            }
//            val responseBody = response.body<OneSignalNotificationResponse>()
//            Result.success(responseBody.id ?: throw IllegalArgumentException("The one signal notification id is null"))
//        } catch (e: ResponseException) {
//            e.printStackTrace()
//            Result.failure(e)
//        } catch (e: Exception) {
//            e.printStackTrace()
//            Result.failure(e)
//        }
//    }
//}