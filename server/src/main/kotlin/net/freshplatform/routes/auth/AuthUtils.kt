package net.freshplatform.routes.auth

import kotlin.time.Duration.Companion.minutes

object AuthUtils {
    val EMAIL_VERIFICATION_TOKEN_EXPIRATION = 15.minutes
    val RESET_PASSWORD_VERIFICATION_TOKEN_EXPIRATION = 15.minutes
    val USER_ACCESS_TOKEN_EXPIRES_IN = 10.minutes

    // TODO: Those two needs to not hardcode things, solve it it the following routes:
    //  verifyEmail, resetPassword, verifyEmailForm and resetPasswordForm

    fun createEmailVerificationLink(baseUrl: String, userId: String, token: String): String {
        return "${baseUrl}/auth/verifyEmailForm?userId=${userId}&token=${token}" // Hardcoded
    }

    fun createResetPasswordLink(baseUrl: String, userId: String, token: String): String {
        return "${baseUrl}/auth/resetPasswordForm?userId=${userId}&token=${token}" // Hardcoded
    }
}