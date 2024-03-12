package net.freshplatform.services.security.payment_methods.zain_cash

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class ZainCashPaymentResponse(
    val source: String = "web",
    val type: String = "MERCHANT_PAYMENT",
    val amount: String,
    val to: String,
    val serviceType: String,
//    val lang: String = "en",
    val orderId: String,
    val currencyConversion: Map<String, String>,
    val referenceNumber: String,
    val redirectUrl: String?,
    val credit: Boolean,
    val status: String,
    val reversed:  Boolean,
//    @Serializable(with = LocalDateTimeSerializer::class)
    val createdAt: String,
//    @Serializable(with = LocalDateTimeSerializer::class)
    val updatedAt: String,
    val id: String
)

@Serializable
data class ZainCashCheckPaymentResponse(
    val to: ZainCashCheckPaymentResponseTo,
    val source: String = "web",
    val type: String = "MERCHANT_PAYMENT",
    val amount: String,
    val serviceType: String,
    val lang: String,
    val orderId: String,
    val currencyConversion: Map<String, String>,
    val referenceNumber: String,
    val redirectUrl: String,
    val credit: Boolean,
    val status: String,
    val reversed: Boolean,
    val createdAt: String,
    val updatedAt: String,
    val due: String?,
    val id: String
)

@Serializable
data class ZainCashCheckPaymentResponseTo(
    val name: String,
    val msisdn: String,
    val currency: String,
    val deleted: Boolean = false,
    @SerialName("pay_by_reference")
    val payByReference: String,
    val createdAt: String,
    val updatedAt: String,
    val id: String
)