package net.freshplatform.services.notifications

import net.freshplatform.data.user.UserDeviceNotificationsToken

interface NotificationsService {
    /**
     * Return the notification id
     * */
    suspend fun sendToDevice(
        title: String,
        body: String,
        deviceNotificationsToken: UserDeviceNotificationsToken,
        data: Map<String, String>? = null
    ): Result<String>
}