package net.freshplatform.data.order.datasources

import net.freshplatform.data.order.Order
import net.freshplatform.data.order.OrderDataSource
import net.freshplatform.data.order.OrderStatus
import com.mongodb.client.model.Filters
import org.bson.types.ObjectId
import org.litote.kmongo.*
import org.litote.kmongo.coroutine.CoroutineDatabase
import java.time.LocalDateTime

class MongoOrderDataSource(
    db: CoroutineDatabase
): OrderDataSource {
    private val orders = db.getCollection<Order>(OrderDataSource.NAME)

    override suspend fun getAll(limit: Int, page: Int, searchQuery: String): List<Order> {
        val skip = (page - 1) * limit
        val filter = Filters.regex(Order::orderNumber.name, ".*${searchQuery}.*".toRegex(RegexOption.IGNORE_CASE).toPattern())
        return (if (searchQuery.isBlank()) orders.find() else orders.find(filter))
            .descendingSort(Order::createdAt)
            .skip(skip)
            .limit(limit)
            .toList()
    }

    override suspend fun getAllOrdersOfUserByUUID(userUUID: String, limit: Int, page: Int): List<Order> {
        val skip = (page - 1) * limit
        return orders.find(Order::userId eq userUUID)
            .descendingSort(Order::createdAt)
            .skip(skip)
            .limit(limit)
            .toList()
    }

    override suspend fun getLast12MonthsOfUserByUUID(userUUID: String): List<Order> {
        val twelveMonthAgo = LocalDateTime.now().withDayOfMonth(1).minusMonths(11)
        return orders.find(
            and(Order::createdAt.gte(twelveMonthAgo), Order::userId eq userUUID)
        ).toList()
    }

    override suspend fun getByOrderNumber(orderNumber: String): Order? {
        return orders.findOne(Order::orderNumber eq orderNumber)
    }

    override suspend fun getByOrderId(orderId: String): Order? {
        return try {
            orders.findOneById(ObjectId(orderId))
        } catch (e: Exception) {
            null
        }
    }

    override suspend fun createOne(order: Order): Boolean {
        return orders.insertOne(order).wasAcknowledged()
    }

    override suspend fun deleteOne(id: String): Boolean {
        return try {
            orders.deleteOneById(ObjectId(id)).wasAcknowledged()
        } catch (e: Exception) {
            false
        }
    }

    override suspend fun updateOrderStatus(id: String, orderStatus: OrderStatus, adminNotes: String, deliveryDate: LocalDateTime?): Boolean {
        return try {
            orders.updateOneById(
                ObjectId(id),
                combine(
                    setValue(Order::status, orderStatus),
                    setValue(Order::adminNotes, adminNotes),
                    setValue(Order::updatedAt, LocalDateTime.now()),
                    setValue(Order::deliveryDate, deliveryDate)
                )
            ).wasAcknowledged()
        } catch (e: Exception) {
            false
        }
    }

    override suspend fun updateIsOrderPaid(id: String, isPaid: Boolean): Boolean {
        return try {
            orders.updateOneById(
                ObjectId(id),
                combine(
                    setValue(Order::isPaid, isPaid),
                    setValue(Order::updatedAt, LocalDateTime.now()),
                )
            ).wasAcknowledged()
        } catch (e: Exception) {
            false
        }
    }
}