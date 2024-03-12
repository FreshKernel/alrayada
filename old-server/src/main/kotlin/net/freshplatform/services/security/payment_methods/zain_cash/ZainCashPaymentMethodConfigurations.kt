package net.freshplatform.services.security.payment_methods.zain_cash

data class ZainCashPaymentMethodConfigurations(
    val url: String,
    val merchantId: String,
    val merchantSecret: String,
    val msiSdn: String
)