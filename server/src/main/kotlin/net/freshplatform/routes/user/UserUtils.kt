package net.freshplatform.routes.user

import kotlin.time.Duration.Companion.days
import kotlin.time.Duration.Companion.minutes

object UserUtils {
    val EMAIL_VERIFICATION_TOKEN_EXPIRATION = 15.minutes
    val RESET_PASSWORD_VERIFICATION_TOKEN_EXPIRATION = 15.minutes
    val USER_ACCESS_TOKEN_EXPIRES_IN = 10.days

    // TODO: Those two needs to not hardcode things, solve it it the following routes:
    //  verifyEmail, resetPassword, verifyEmailForm and resetPasswordForm

    fun createEmailVerificationLink(baseUrl: String, userId: String, token: String): String {
        return "${baseUrl}/user/verifyEmailForm?userId=${userId}&token=${token}" // Hardcoded
    }

    fun createResetPasswordLink(baseUrl: String, userId: String, token: String): String {
        return "${baseUrl}/user/resetPasswordForm?userId=${userId}&token=${token}" // Hardcoded
    }
}