package net.freshplatform.routes.user

import net.freshplatform.data.user.User
import net.freshplatform.services.telegram_bot.TelegramBotService
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

    suspend fun notifyAdminsUserRegistration(user: User, telegramBotService: TelegramBotService) {
        val message = buildString {
            append("A new user has inserted in the database\n")
            append("Lab owner name: <b>${user.info.labOwnerName}</b>\n")
            append("Lab name: <b>${user.info.labName}</b>\n")
            append("Lab owner phone: <b>${user.info.labOwnerPhoneNumber}</b>\n")
            append("Lab phone: <b>${user.info.labPhoneNumber}</b>\n")
            append("Email address: <b>${user.email}</b>\n")
        }
        telegramBotService.sendMessage(message)
    }
}