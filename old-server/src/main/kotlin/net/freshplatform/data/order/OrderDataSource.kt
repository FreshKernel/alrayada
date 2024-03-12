package net.freshplatform.data.order

import java.time.LocalDateTime

interface OrderDataSource {
    companion object {
        const val NAME = "orders"
    }
    suspend fun getAll(limit: Int = 10, page: Int = 1, searchQuery: String = ""): List<Order>
    suspend fun getAllOrdersOfUserByUUID(userUUID: String, limit: Int = 10, page: Int = 1): List<Order>
    suspend fun getLast12MonthsOfUserByUUID(userUUID: String): List<Order>
    suspend fun getByOrderNumber(orderNumber: String): Order?
    suspend fun getByOrderId(orderId: String): Order?
    suspend fun createOne(order: Order): Boolean
    suspend fun deleteOne(id: String): Boolean
    suspend fun updateOrderStatus(id: String, orderStatus: OrderStatus, adminNotes: String = "", deliveryDate: LocalDateTime?): Boolean
    suspend fun updateIsOrderPaid(id: String, isPaid: Boolean): Boolean
}