package net.freshplatform.services.security.payment_methods

import net.freshplatform.data.order.PaymentMethod

class PaymentMethodException(val error: String = ""): Exception(error)

interface PaymentMethodsService {
    @Throws(PaymentMethodException::class)
    suspend fun processPayment(
        paymentMethod: PaymentMethod,
        paymentData: Map<String, Any>,
        orderNumber: String,
        amount: Double,
        serviceType: String,
        baseUrl: String
    ): Any
}