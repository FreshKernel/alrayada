package net.freshplatform.services.notifications

import kotlinx.serialization.Serializable

@Serializable
data class Notification(
    val message: NotificationMessage
)

@Serializable
data class NotificationMessage(
    val token: String? = null,
    val topic: String? = null,
    val notification: AppNotification? = null,
    val data: Map<String, String>? = null
)

@Serializable
data class AppNotification(
    val title: String? = null,
    val body: String? = null
)