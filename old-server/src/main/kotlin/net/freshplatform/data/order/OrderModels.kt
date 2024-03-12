package net.freshplatform.data.order

import net.freshplatform.data.product.ProductResponse
import net.freshplatform.data.user.UserData
import net.freshplatform.utils.helpers.LocalDateTimeSerializer
import kotlinx.serialization.Serializable
import org.bson.codecs.pojo.annotations.BsonId
import org.bson.types.ObjectId
import java.time.LocalDateTime

@Serializable
data class OrderItem(
    val productId: String,
    val quantity: Int,
    val notes: String
)

data class Order(
    @BsonId
    val id: ObjectId = ObjectId(),
    val orderNumber: String,
    val userId: String,
    val items: List<OrderItem>,
    val notes: String,
    val adminNotes: String = "",
    val deliveryDate: LocalDateTime?,
    val totalOriginalPrice: Double,
    val totalSalePrice: Double,
    val paymentMethod: PaymentMethod = PaymentMethod.Cash,
    val paymentMethodData: Map<String, String>,
    val status: OrderStatus = OrderStatus.Pending,
    val isPaid: Boolean = false,
    val createdAt: LocalDateTime,
    val updatedAt: LocalDateTime
) {
    fun stringId() = id.toString()
    fun toResponse(items: List<OrderItemResponse>, userData: UserData?) = OrderResponse(
        id = id.toString(),
        orderNumber = orderNumber,
        userId = userId,
        items = items,
        notes = notes,
        adminNotes = adminNotes,
        deliveryDate = deliveryDate,
        totalOriginalPrice = totalOriginalPrice,
        totalSalePrice = totalSalePrice,
        paymentMethod = paymentMethod,
        paymentMethodData = paymentMethodData,
        status = status,
        isPaid = isPaid,
        createdAt = createdAt,
        updatedAt = updatedAt,
        userData = userData
    )
}

@Serializable
data class OrderRequest(
    val items: List<OrderItem>,
    val notes: String = "",
    val paymentMethod: PaymentMethod = PaymentMethod.Cash,
) {
    fun validate(): String? = when {
        items.isEmpty() -> "Items is empty"
        items.any { it.quantity < 0 } -> "All the item quantity should be greater than 0"
        items.any { it.productId.isBlank() } -> "All the product ids should not be empty"
        else -> null
    }
}

@Serializable
data class OrderItemResponse(
    val product: ProductResponse,
    val quantity: Int,
    val notes: String
)

@Serializable
data class OrderResponse(
    val id: String,
    val orderNumber: String,
    val userId: String,
    val items: List<OrderItemResponse>,
    val notes: String = "",
    val adminNotes: String = "",
    @Serializable(with = LocalDateTimeSerializer::class)
    val deliveryDate: LocalDateTime?,
    val totalOriginalPrice: Double,
    val totalSalePrice: Double,
    val paymentMethod: PaymentMethod = PaymentMethod.Cash,
    val paymentMethodData: Map<String, String>,
    val status: OrderStatus = OrderStatus.Pending,
    val isPaid: Boolean,
    @Serializable(with = LocalDateTimeSerializer::class)
    val createdAt: LocalDateTime,
    @Serializable(with = LocalDateTimeSerializer::class)
    val updatedAt: LocalDateTime,
    val userData: UserData? // for admin only
)

@Serializable
enum class OrderStatus {
//    Created,
    Pending,
//    Process,
    Approved,
    Rejected,
    Cancelled
}

enum class PaymentMethod {
    Cash,
    ZainCash,
    CreditCard
}