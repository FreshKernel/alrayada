package net.freshplatform.routes.orders

import kotlinx.serialization.Serializable

@Serializable
data class OrderIdRequest(
    val orderId: String
) {
    fun validate(): String? {
        return when {
            orderId.isBlank() -> "Please enter valid order number"
            else -> null
        }
    }
}
