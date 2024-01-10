package net.freshplatform.utils.constants

import net.freshplatform.services.secret_variables.SecretVariablesName
import net.freshplatform.services.secret_variables.SecretVariablesService
import net.freshplatform.services.security.payment_methods.zain_cash.ZainCashPaymentMethodConfigurations
import net.freshplatform.utils.extensions.isProductionMode
import com.auth0.jwt.JWT
import com.auth0.jwt.algorithms.Algorithm
import com.auth0.jwt.exceptions.JWTVerificationException
import com.auth0.jwt.interfaces.DecodedJWT
import java.util.*

object PaymentMethodsConstants {
    object ZainCash {

        private const val TESTING_URL = "https://test.zaincash.iq/"
        private const val PRODUCTION_URL = "https://api.zaincash.iq/"

        private const val TESTING_MERCHANT_ID = "5ffacf6612b5777c6d44266f"
        private const val TESTING_MERCHANT_SECRET =
            "\$2y\$10\$hBbAZo2GfSSvyqAyV2SaqOfYewgYpfR1O19gIh4SqyGWdmySZYPuS"

        private const val TESTING_MSISDN = "9647835077893" // wallet phone number

        private val url =
            if (isProductionMode()) PRODUCTION_URL else SecretVariablesService.getString(
                SecretVariablesName.ZainCashApiUrl,
                TESTING_URL
            )

        private val merchantId =
            if (isProductionMode()) SecretVariablesService.getString(
                SecretVariablesName.ZainCashMerchantId,
                TESTING_MERCHANT_ID
            ) else TESTING_MERCHANT_ID

        private val merchantSecret =
            if (isProductionMode()) SecretVariablesService.getString(
                SecretVariablesName.ZainCashMerchantSecret,
                TESTING_MERCHANT_SECRET,
            ) else TESTING_MERCHANT_SECRET

        private val msiSdn = if (isProductionMode()) SecretVariablesService.getString(
            SecretVariablesName.ZainCashMerchantMsiSdn,
            TESTING_MSISDN,
        ) else TESTING_MSISDN
        val configurations = ZainCashPaymentMethodConfigurations(url, merchantId, merchantSecret, msiSdn)

        fun generateCreatePaymentToken(
            zainCashConfigurations: ZainCashPaymentMethodConfigurations,
            amountInDollars: Double,
            serviceType: String,
            orderNumber: String,
            baseUrl: String
        ): String = JWT.create()
            .withClaim(
                "amount",
                amountInDollars * ((SecretVariablesService.getString(
                    SecretVariablesName.DollarInDinar,
                    Constants.DEFAULT_DOLLAR_IN_DINAR.toString()
                )).toIntOrNull()
                    ?: Constants.DEFAULT_DOLLAR_IN_DINAR)
            )
            .withClaim("serviceType", serviceType)
            .withClaim("msisdn", zainCashConfigurations.msiSdn)
            .withClaim("orderId", orderNumber)
            .withClaim("redirectUrl", "${baseUrl}/api/orders/paymentGateways/zainCash/afterPaymentRedirect")
            .withExpiresAt(
                Date(System.currentTimeMillis() + (4 * 1000 * 60 * 60)),
            )
            .sign(Algorithm.HMAC256(zainCashConfigurations.merchantSecret))

        fun generateCheckPaymentToken(
            zainCashConfigurations: ZainCashPaymentMethodConfigurations,
            transactionId: String
        ): String = JWT.create()
            .withClaim("id", transactionId)
            .withClaim("msisdn", zainCashConfigurations.msiSdn)
            .withExpiresAt(
                Date(System.currentTimeMillis() + (4 * 1000 * 60 * 60)),
            )
            .sign(Algorithm.HMAC256(zainCashConfigurations.merchantSecret))

        fun verifyPaymentRedirectToken(
            token: String
        ): DecodedJWT = try {
            JWT.require(Algorithm.HMAC256(merchantSecret))
                .build()
                .verify(token)
        } catch (e: JWTVerificationException) {
            throw e
        }

        fun isOrderStatusCompleted(transactionStatus: String): Boolean =
            transactionStatus == "success" || transactionStatus == "completed"
    }
}