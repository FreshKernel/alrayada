package net.freshplatform.routes.orders.admin

import kotlinx.serialization.Serializable
import net.freshplatform.utils.helpers.LocalDateTimeSerializer
import java.time.LocalDateTime

@Serializable
data class RejectOrderRequest(
    val orderId: String,
    val adminNotes: String = "",
) {
    fun validate(): String? {
        return when {
            orderId.isBlank() -> "Please enter valid order number"
            else -> null
        }
    }
}

@Serializable
data class ApproveOrderRequest(
    val orderId: String,
    val adminNotes: String = "",
    @Serializable(with = LocalDateTimeSerializer::class)
    val deliveryDate: LocalDateTime
) {
    fun validate(): String? {
        return when {
            orderId.isBlank() -> "Please enter valid order number"
            else -> null
        }
    }
}