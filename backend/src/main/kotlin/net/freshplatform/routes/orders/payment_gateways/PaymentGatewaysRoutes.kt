package net.freshplatform.routes.orders.payment_gateways

import net.freshplatform.data.order.OrderDataSource
import net.freshplatform.routes.orders.OrderRoutesUtils
import net.freshplatform.utils.constants.Constants
import net.freshplatform.utils.constants.PaymentMethodsConstants
import net.freshplatform.utils.extensions.request.requireAuthenticatedUser
import net.freshplatform.utils.extensions.request.requireParameter
import net.freshplatform.utils.extensions.request.respondJsonText
import com.auth0.jwt.exceptions.JWTVerificationException
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.response.*
import io.ktor.server.routing.*

class PaymentGatewaysRoutes(
    private val router: Route,
    private val orderDataSource: OrderDataSource
) {
    fun zainCash() = router.route("/zainCash") {
        get("/afterPaymentRedirect") {
            try {
                val token = call.requireParameter("token")
                val zainCash = PaymentMethodsConstants.ZainCash
                val decodedJwt = zainCash.verifyPaymentRedirectToken(token)
                val status = decodedJwt.getClaim("status").asString() ?: kotlin.run {
                    call.respondJsonText(HttpStatusCode.InternalServerError, "orderStatus from zain cash api is null")
                    return@get
                }
                val success = zainCash.isOrderStatusCompleted(status)
                if (!success) {
                    call.respondJsonText(HttpStatusCode.UnprocessableEntity, "Order hasn't paid, please try again and contact us")
                    return@get
                }
                val orderNumber = decodedJwt.getClaim("orderid").asString() ?: kotlin.run {
                    call.respondJsonText(HttpStatusCode.InternalServerError, "orderId from zain cash api is null")
                    return@get
                }
                val order = orderDataSource.getByOrderNumber(orderNumber) ?: kotlin.run {
                    call.respondJsonText(HttpStatusCode.NotFound, "Can't find any matching order.")
                    return@get
                }
                val isOrderPaid = OrderRoutesUtils.isOrderPaid(
                    call,
                    order,
                    orderDataSource
                )

                // To mobile app
                call.respondRedirect("${Constants.PRODUCTION_WEBSITE}/orders/paymentGateways/zainCash/afterPaymentRedirect?orderNumber=$orderNumber&isOrderPaid=$isOrderPaid")

//                HttpService.client.get(
//                    "https://eovd0lxr9zu4n7s.m.pipedream.net" +
//                            "?status=$status&isOrderPaid=$isOrderPaid&token=${decodedJwt.payload}",
//                )
            } catch (e: JWTVerificationException) {
                call.respondJsonText(HttpStatusCode.BadRequest, "Token is not correct")
            }
        }
        authenticate {
            get("/checkTransaction") {
                val token = call.requireParameter("token")
                val user = call.requireAuthenticatedUser()
                try {
                    val zainCash = PaymentMethodsConstants.ZainCash
                    val decodedJwt = zainCash.verifyPaymentRedirectToken(token)
                    val status = decodedJwt.getClaim("status").asString() ?: kotlin.run {
                        call.respondJsonText(
                            HttpStatusCode.InternalServerError,
                            "orderStatus from zain cash api is null"
                        )
                        return@get
                    }
                    val success = zainCash.isOrderStatusCompleted(status)
                    if (!success) {
                        call.respondJsonText(HttpStatusCode.UnprocessableEntity, "Order hasn't paid, please try again and contact us.")
                        return@get
                    }
                    val orderNumber = decodedJwt.getClaim("orderid").asString() ?: kotlin.run {
                        call.respondJsonText(HttpStatusCode.InternalServerError, "orderId from zain cash api is null")
                        return@get
                    }
                    val order = orderDataSource.getByOrderNumber(orderNumber) ?: kotlin.run {
                        call.respondJsonText(HttpStatusCode.NotFound, "Can't find any matching order.")
                        return@get
                    }
                    if (order.userId != user.stringId()) {
                        call.respondJsonText(HttpStatusCode.BadRequest, "Can't find any matching order.")
                        return@get
                    }
                    val isOrderPaid = OrderRoutesUtils.isOrderPaid(
                        call,
                        order,
                        orderDataSource
                    )

                    if (!isOrderPaid) {
                        call.respondJsonText(HttpStatusCode.BadRequest, "Order hasn't paid")
                        return@get
                    }

                    call.respondJsonText(HttpStatusCode.OK, "Order $orderNumber has paid with zain cash successfully!")
//                    HttpService.client.get(
//                        "https://eovd0lxr9zu4n7s.m.pipedream.net" +
//                                "?status=$status&isOrderPaid=$isOrderPaid&token=${decodedJwt.payload}",
//                    )
                } catch (e: JWTVerificationException) {
                    call.respondJsonText(HttpStatusCode.BadRequest, "Token is not correct")
                }
            }
        }
    }
}