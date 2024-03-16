package net.freshplatform.routes.auth

import net.freshplatform.services.security.token_verification.TokenVerification
import kotlin.time.Duration.Companion.minutes

object AuthUtils {
    val EMAIL_VERIFICATION_TOKEN_EXPIRATION = 15.minutes
    val RESET_PASSWORD_VERIFICATION_TOKEN_EXPIRATION = 15.minutes

    // TODO: Those two needs to be updated

    fun createEmailVerificationLink(baseUrl: String, email: String, emailVerificationToken: String): String {
        return "${baseUrl}/auth/verifyEmail?email=${email}&token=${emailVerificationToken}"
    }
    fun createResetPasswordLink(baseUrl: String, email: String, resetPasswordVerification: TokenVerification): String {
        return "${baseUrl}/auth/resetPassword?email=${email}&token=${resetPasswordVerification.token}"
    }
}