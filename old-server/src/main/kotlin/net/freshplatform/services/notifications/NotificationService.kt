package net.freshplatform.services.notifications

import net.freshplatform.data.user.UserDeviceNotificationsToken

open class NotificationServiceException(message: String): Exception(message)
class NotificationsServiceDeviceTokenEmptyException(message: String) : NotificationServiceException("Device token should not be empty: $message")
class NotificationServiceDeviceTokenNotValidException(message: String = "") : NotificationServiceException("Device token should be valid: $message")

interface NotificationService {
    @Throws(NotificationServiceException::class)
    suspend fun sendToDevice(title: String, body: String, deviceToken: UserDeviceNotificationsToken, data: Map<String, String>? = null): String?
}