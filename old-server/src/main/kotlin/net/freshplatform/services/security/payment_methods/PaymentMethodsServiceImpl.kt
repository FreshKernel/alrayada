package net.freshplatform.services.security.payment_methods

import net.freshplatform.data.order.PaymentMethod
import net.freshplatform.services.http_client.HttpService
import net.freshplatform.services.security.payment_methods.zain_cash.ZainCashPaymentRequest
import net.freshplatform.services.security.payment_methods.zain_cash.ZainCashPaymentResponse
import net.freshplatform.utils.constants.PaymentMethodsConstants
import io.ktor.client.*
import io.ktor.client.call.*
import io.ktor.client.request.*
import io.ktor.client.statement.*
import io.ktor.http.*
import java.util.*

class PaymentMethodsServiceImpl(
    private val client: HttpClient = HttpService.client
) : PaymentMethodsService {
    @Throws(PaymentMethodException::class)
    override suspend fun processPayment(
        paymentMethod: PaymentMethod,
        paymentData: Map<String, Any>,
        orderNumber: String,
        amount: Double,
        serviceType: String,
        baseUrl: String
    ): Any {
        return when (paymentMethod) {
            PaymentMethod.Cash -> Unit
            PaymentMethod.ZainCash -> {
                val zainCashConfigurations = PaymentMethodsConstants.ZainCash.configurations
                val token = PaymentMethodsConstants.ZainCash.generateCreatePaymentToken(
                    zainCashConfigurations,
                    amount,
                    "A order",
                    orderNumber,
                    baseUrl
                )
                try {
                    val response = client.post("${zainCashConfigurations.url}transaction/init") {
                        contentType(ContentType.Application.Json)
                        setBody(ZainCashPaymentRequest(token, zainCashConfigurations.merchantId))
                    }
                    return response.body<ZainCashPaymentResponse>()
                } catch (e: Exception) {
                    println(e.message)
                    throw PaymentMethodException(e.message.toString())
                }
            }

            PaymentMethod.CreditCard -> TODO()
        }
    }
}