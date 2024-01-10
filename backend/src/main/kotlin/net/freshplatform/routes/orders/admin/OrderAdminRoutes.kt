package net.freshplatform.routes.orders.admin

import net.freshplatform.data.order.OrderDataSource
import net.freshplatform.data.order.OrderStatus
import net.freshplatform.data.user.UserDataSource
import net.freshplatform.routes.orders.OrderIdRequest
import net.freshplatform.services.notifications.NotificationService
import net.freshplatform.services.notifications.NotificationServiceException
import net.freshplatform.utils.extensions.request.receiveBodyAs
import net.freshplatform.utils.extensions.request.requireAdminUser
import net.freshplatform.utils.extensions.request.respondJsonText
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.request.*
import io.ktor.server.routing.*
import java.time.format.DateTimeFormatter

class OrderAdminRoutes(
    private val router: Route,
    private val orderDataSource: OrderDataSource,
    private val userDataSource: UserDataSource,
    private val notificationService: NotificationService
) {
    fun deleteOrder() = router.authenticate {
        delete("/deleteOrder") {
            call.requireAdminUser()
            val request = call.receiveBodyAs<OrderIdRequest>()
            val order = orderDataSource.getByOrderId(request.orderId) ?: kotlin.run {
                call.respondJsonText(HttpStatusCode.Conflict, "There is no order with that number.")
                return@delete
            }
            val deleteSuccess = orderDataSource.deleteOne(order.id.toString())
            if (!deleteSuccess) {
                call.respondJsonText(HttpStatusCode.InternalServerError, "Error while delete the order.")
                return@delete
            }
            call.respondJsonText(HttpStatusCode.NoContent, "Order has been successfully deleted!")
        }
    }

    fun approveOrder() = router.authenticate {
        patch("/approveOrder") {
            call.requireAdminUser()
            val request = call.receive<ApproveOrderRequest>()
            val error = request.validate()
            if (error != null) {
                call.respondJsonText(HttpStatusCode.BadRequest, error)
                return@patch
            }
            val order = orderDataSource.getByOrderId(request.orderId) ?: kotlin.run {
                call.respondJsonText(HttpStatusCode.Conflict, "There is no order by this id")
                return@patch
            }
            val success = orderDataSource.updateOrderStatus(
                order.id.toString(),
                OrderStatus.Approved,
                request.adminNotes,
                request.deliveryDate
            )
            if (!success) {
                call.respondJsonText(HttpStatusCode.InternalServerError, "Error while update the order status")
                return@patch
            }
            var notificationSentSuccess = false
            userDataSource.getUserByUUID(order.userId)?.let { user ->


                notificationSentSuccess = try {
                    val messageId = notificationService.sendToDevice(
                        title = "Your order #${order.orderNumber} has been approved!",
                        body = buildString {
                            append(if (request.adminNotes.isBlank()) "There is no any other notes from the admin" else "Admin notes: ${request.adminNotes}")

                            append("\n Delivery date: ${DateTimeFormatter.ofPattern("yyyy-MM-dd").format(request.deliveryDate)}")
                        },
                        deviceToken = user.deviceNotificationsToken
                    )
                    messageId != null
                } catch (e: NotificationServiceException) {
                    false
                }
            }
            call.respondJsonText(
                HttpStatusCode.OK,
                "Order has been successfully approved, notification ${if (notificationSentSuccess) "has been successfully sent" else "can't be send"}"
            )
        }
    }

    fun rejectOrder() = router.authenticate {
        patch("/rejectOrder") {
            call.requireAdminUser()
            val request = call.receiveBodyAs<RejectOrderRequest>()
            val error = request.validate()
            if (error != null) {
                call.respondJsonText(HttpStatusCode.BadRequest, error)
                return@patch
            }
            val order = orderDataSource.getByOrderId(request.orderId) ?: kotlin.run {
                call.respondJsonText(HttpStatusCode.Conflict, "There is no order by this id")
                return@patch
            }
            val success =
                orderDataSource.updateOrderStatus(order.id.toString(), OrderStatus.Rejected, request.adminNotes, null)
            if (!success) {
                call.respondJsonText(HttpStatusCode.InternalServerError, "Error while update the order status")
                return@patch
            }
            var notificationSentSuccess = false
            userDataSource.getUserByUUID(order.userId)?.let { user ->
                notificationSentSuccess = try {
                    val messageId = notificationService.sendToDevice(
                        title = "Your order #${order.orderNumber} has been rejected!",
                        body = if (request.adminNotes.isBlank()) "There is no any other notes." else "Admin order notes: ${request.adminNotes}",
                        deviceToken = user.deviceNotificationsToken
                    )
                    messageId != null
                } catch (e: NotificationServiceException) {
                    false
                }
            }
            call.respondJsonText(
                HttpStatusCode.OK,
                "Order has been successfully rejected, notification ${if (notificationSentSuccess) "has been successfully sent" else "can't be send"}"
            )
        }
    }
}