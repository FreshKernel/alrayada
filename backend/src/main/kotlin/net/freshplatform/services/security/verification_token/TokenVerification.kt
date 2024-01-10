package net.freshplatform.services.security.verification_token

import kotlinx.serialization.Serializable
import java.util.*

@Serializable
data class TokenVerification(
    val name: String,
    val token: String,
    val expiresAt: Long
) {
    fun minutesToExpire(): Int {
        if (hasTokenExpired()) return 0
        val expiresAt = Date(expiresAt)
        val currentDate = Date(System.currentTimeMillis())
        val diffInMillis = expiresAt.time - currentDate.time
        return (diffInMillis / (1000 * 60)).toInt()
    }
    fun hasTokenExpired(): Boolean {
        val expiresAt = Date(expiresAt)
        val currentDate = Date(System.currentTimeMillis())
        return currentDate.after(expiresAt)
    }
}