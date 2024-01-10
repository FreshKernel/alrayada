package net.freshplatform.routes.orders

import net.freshplatform.data.order.*
import net.freshplatform.data.product.ProductDataSource
import net.freshplatform.data.user.UserData
import net.freshplatform.data.user.UserDataSource
import net.freshplatform.services.security.payment_methods.PaymentMethodException
import net.freshplatform.services.security.payment_methods.PaymentMethodsService
import net.freshplatform.services.security.payment_methods.zain_cash.ZainCashPaymentResponse
import net.freshplatform.services.telegram.TelegramBotService
import net.freshplatform.utils.constants.PaymentMethodsConstants
import net.freshplatform.utils.extensions.request.*
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import java.time.LocalDateTime
import java.time.ZoneId
import java.util.*
import kotlin.collections.set
import kotlin.random.Random

class OrderRoutes(
    private val router: Route,
    private val orderDataSource: OrderDataSource,
    private val productDataSource: ProductDataSource,
    private val userDataSource: UserDataSource,
    private val telegramBotService: TelegramBotService,
    private val paymentMethodsService: PaymentMethodsService,
) {
    fun getAll() = router.authenticate {
        get("/") {
            val currentUser = call.requireAuthenticatedUser()
            val isAdmin = currentUser.hasAdminPrivileges()
            val page = call.requestPageParameter()
            val limit = call.requestLimitParameter()
            val searchQuery = if (isAdmin) call.getParameter("searchQuery") else ""
            val orders = if (!isAdmin) orderDataSource.getAllOrdersOfUserByUUID(
                currentUser.stringId(),
                limit,
                page
            ) else orderDataSource.getAll(limit, page, searchQuery)
            val ordersResponse = mutableListOf<OrderResponse>()
            var userData: UserData? = null
            orders.forEach { order ->
                val orderItems = order.items
                val ids = orderItems.map { it.productId }
                val productsOfOrders = productDataSource.getAllByIds(ids)
                    .map { it.toResponse(call) }
                if (isAdmin) {
                    userData = (userDataSource.getUserByUUID(order.userId)?.data ?: UserData.unknown())
                }
                val orderResponse = order.toResponse(
                    items = productsOfOrders.map { productResponse ->
                        val orderItem = orderItems.find { it.productId == productResponse.id }
                        OrderItemResponse(
                            product = productResponse,
                            quantity = orderItem?.quantity ?: 1,
                            notes = orderItem?.notes ?: ""
                        )
                    }, userData = userData // for admin only
                )
                ordersResponse.add(orderResponse)
            }
            call.respond(HttpStatusCode.OK, ordersResponse)
        }
    }

    private suspend fun generateUniqueOrderNumber(): Int {
        fun generateRandomOrderNumber(): Int =
            Random.nextInt(
                from = 10000,
                until = 99999
            )
        // Try to generate unique order id
        var orderNumber = generateRandomOrderNumber()

        while (true) {
            val orderNumberUsed =
                orderDataSource.getByOrderNumber(
                    orderNumber.toString()
                ) != null
            if (!orderNumberUsed) {
                break
            }
            orderNumber = generateRandomOrderNumber()
        }
        return orderNumber
    }


    fun checkout() = router.authenticate {
        post("/checkout") {
            val request = call.receiveBodyAs<OrderRequest>()
            val requestBodyError = request.validate()
            if (requestBodyError != null) {
                call.respondJsonText(HttpStatusCode.BadRequest, "$requestBodyError.")
                return@post
            }
            val currentUser = call.requireAuthenticatedUser()
            if (!currentUser.accountActivated) {
                call.respondJsonText(HttpStatusCode.Forbidden, "Your account is not yet activated.")
                return@post
            }
            val products = productDataSource.getAllByIds(request.items.map { it.productId }) // product ids
            if (products.isEmpty()) {
                call.respondJsonText(HttpStatusCode.BadRequest, "Products is empty")
                return@post
            }
            val totalOriginalPrice = products.fold(0.0) { previous, product ->
                val quantity = request.items.find { it.productId == product.id.toString() }!!.quantity
                previous + (product.originalPrice * quantity)
            }
            val totalSalePrice = products.fold(0.0) { previous, product ->
                val quantity = request.items.find { it.productId == product.id.toString() }!!.quantity
                previous + (product.findSalePrice() * quantity)
            }

            val paymentMethodData = mutableMapOf<String, String>()

            val orderNumber = generateUniqueOrderNumber().toString()
            val serverBaseUrl = call.getServerClientUrl()

            // create payment gateway order
            when (request.paymentMethod) {
                PaymentMethod.Cash -> Unit
                PaymentMethod.ZainCash -> {
                    try {
                        val data = paymentMethodsService.processPayment(
                            request.paymentMethod,
                            mapOf(),
                            orderNumber,
                            totalSalePrice,
                            "A order",
                            serverBaseUrl
                        ) as ZainCashPaymentResponse
                        val transactionId = data.id
                        paymentMethodData["transactionId"] = data.id
                        paymentMethodData["payUrl"] =
                            "${PaymentMethodsConstants.ZainCash.configurations.url}transaction/pay?id=$transactionId"
                    } catch (e: PaymentMethodException) {
                        call.respondJsonText(HttpStatusCode.InternalServerError, e.message.toString())
                        return@post
                    }
                }

                PaymentMethod.CreditCard -> Unit
            }

            val date = LocalDateTime.now()
            val order = Order(
                userId = currentUser.stringId(),
                orderNumber = orderNumber,
                status = OrderStatus.Pending,
                paymentMethod = request.paymentMethod,
                paymentMethodData = paymentMethodData,
                totalOriginalPrice = totalOriginalPrice,
                totalSalePrice = totalSalePrice,
                updatedAt = date,
                createdAt = date,
                items = request.items,
                notes = request.notes,
                deliveryDate = null,
            )
            val success = orderDataSource.createOne(order)
            if (!success) {
                call.respondJsonText(HttpStatusCode.InternalServerError, "Error while create the order.")
                return@post
            }
            val orderResponse = order.toResponse(
                items = order.items.map { cartItem ->
                    OrderItemResponse(
                        quantity = cartItem.quantity,
                        product = products.find { product ->
                            product.id == cartItem.productId
                        }!!.toResponse(call),
                        notes = cartItem.notes
                    )
                },
                userData = null // no need for this, we use it only for admin to view the orders
            )
            val message = buildString {
                append("You have new order from '<b>${currentUser.data.labName}</b>' Lab")
                append("\n")
                append("Order Items: \n")
                orderResponse.items.forEach {
                    append(it.product.name)
                    append(" * ${it.quantity}")
                    append("\n")
                }
            }
            telegramBotService.sendMessage(
                text = message,
            )
            call.respond(HttpStatusCode.Created, orderResponse)
        }
    }

    fun isOrderPaidRoute() = router.authenticate {
        get("/isOrderPaid") {
            val user = call.requireAuthenticatedUser()
            val orderNumber = call.requireParameter("orderNumber")
            val order = orderDataSource.getByOrderNumber(orderNumber) ?: kotlin.run {
                call.respondJsonText(HttpStatusCode.NotFound, "Can't find any matching order.")
                return@get
            }
            if (order.userId != user.stringId() && !user.hasAdminPrivileges()) {
                call.respondJsonText(HttpStatusCode.NotFound, "Can't find any matching order.")
                return@get
            }
            val isOrderPaid = OrderRoutesUtils.isOrderPaid(
                call,
                order,
                orderDataSource
            )
            call.respond(HttpStatusCode.OK, isOrderPaid.toString())
        }
    }

    fun cancelOrder() = router.authenticate {
        patch("/cancelOrder") {
            val currentUser = call.requireAuthenticatedUser()
            val request = call.receiveBodyAs<OrderIdRequest>()
            val error = request.validate()
            if (error != null) {
                call.respondJsonText(HttpStatusCode.BadRequest, error)
                return@patch
            }
            val order = orderDataSource.getByOrderId(request.orderId) ?: kotlin.run {
                call.respondJsonText(HttpStatusCode.Conflict, "We can't find this order.")
                return@patch
            }
            if (order.userId != currentUser.uuid) {
                call.respondJsonText(HttpStatusCode.Forbidden, "This is not your order!")
                return@patch
            }
            if (order.status != OrderStatus.Pending) {
                call.respondJsonText(
                    HttpStatusCode.Conflict,
                    "You can only cancel the order when it's on the pending status"
                )
                return@patch
            }
            val success = orderDataSource.updateOrderStatus(order.id.toString(), OrderStatus.Cancelled, "", null)
            if (!success) {
                call.respondJsonText(HttpStatusCode.InternalServerError, "Server error while cancel the order.")
                return@patch
            }
            val message = buildString {
                append("The order #${order.orderNumber} from '${currentUser.data.labName}' Lab has been cancelled by the user.")
            }
            telegramBotService.sendMessage(text = message)
            call.respondJsonText(HttpStatusCode.OK, "Order has been cancelled")
        }
    }

    fun getStatistics() = router.authenticate {
        get("/statistics") {
            val currentUser = call.requireAuthenticatedUser()
            val orders = orderDataSource.getLast12MonthsOfUserByUUID(currentUser.uuid)
            val monthlyTotals = mutableListOf<MonthlyTotal>()
            orders.forEach { order ->
                val date = Date.from(order.createdAt.atZone(ZoneId.systemDefault()).toInstant())
                val calendar = Calendar.getInstance().apply { time = date }
                val month = calendar.get(Calendar.MONTH) + 1
                val filtered = monthlyTotals.firstOrNull { it.month == month }
                if (filtered == null) {
                    monthlyTotals.add(MonthlyTotal(month, order.totalSalePrice))
                } else {
                    val index = monthlyTotals.indexOf(filtered)
                    val current = monthlyTotals[index]
                    monthlyTotals[index] = MonthlyTotal(month, current.total + order.totalSalePrice)
                }
            }
            call.respond(HttpStatusCode.OK, monthlyTotals)
        }
    }
}