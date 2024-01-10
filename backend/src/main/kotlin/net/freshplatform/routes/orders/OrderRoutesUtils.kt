package net.freshplatform.routes.orders

import net.freshplatform.data.order.Order
import net.freshplatform.data.order.OrderDataSource
import net.freshplatform.data.order.PaymentMethod
import net.freshplatform.services.http_client.HttpService
import net.freshplatform.services.security.payment_methods.zain_cash.ZainCashPaymentRequest
import net.freshplatform.utils.constants.PaymentMethodsConstants
import net.freshplatform.utils.extensions.request.respondJsonText
import io.ktor.client.call.*
import io.ktor.client.request.*
import io.ktor.http.*
import io.ktor.server.application.*
import kotlinx.serialization.json.Json
import kotlinx.serialization.json.jsonObject
import kotlinx.serialization.json.jsonPrimitive

object OrderRoutesUtils {
    class TransactionIdNull : Exception("The transaction id of payment gateway to pay order is null")

    suspend fun isOrderPaid(
        call: ApplicationCall,
        order: Order,
        orderDataSource: OrderDataSource
    ): Boolean {
        var isTransactionPaid = false
        when (order.paymentMethod) {
            PaymentMethod.Cash -> {
                call.respondJsonText(
                    HttpStatusCode.BadRequest,
                    "The app has no information if the order is paid or not for this payment method"
                )
            }

            PaymentMethod.ZainCash -> {
                val transactionId = order.paymentMethodData["transactionId"] ?: kotlin.run {
                    call.respondJsonText(
                        HttpStatusCode.InternalServerError,
                        "Transaction id is not in the order data."
                    )
                    throw TransactionIdNull()
                }
                val zainCashConfigurations = PaymentMethodsConstants.ZainCash.configurations
                val response = HttpService.client.post("${zainCashConfigurations.url}transaction/get") {
                    contentType(ContentType.Application.Json)
                    setBody(
                        ZainCashPaymentRequest(
                            PaymentMethodsConstants.ZainCash.generateCheckPaymentToken(
                                zainCashConfigurations,
                                transactionId
                            ), zainCashConfigurations.merchantId,
                        ),
                    )
                }
                val responseJson = response.body<String>()
                val status = Json.parseToJsonElement(responseJson).jsonObject["status"]?.jsonPrimitive?.content ?: "unknown"
                println("Zain cash transaction = $responseJson")
//                    val transactionStatus = responseJson["status"] as String
                val zainCash = PaymentMethodsConstants.ZainCash
                isTransactionPaid = zainCash.isOrderStatusCompleted(status)
            }

            PaymentMethod.CreditCard -> Unit
        }
        if (isTransactionPaid && !order.isPaid) {
            orderDataSource.updateIsOrderPaid(order.stringId(), true)
        }
        return isTransactionPaid
    }
}