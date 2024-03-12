package net.freshplatform.services.security.payment_methods.zain_cash

import kotlinx.serialization.Serializable

@Serializable
data class ZainCashPaymentRequest(
    val token: String,
    val merchantId: String,
//    val lang: String = "en"
)
