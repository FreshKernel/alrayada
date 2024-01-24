package net.freshplatform.services.security.token_verification

import kotlinx.datetime.Clock
import kotlinx.datetime.Instant
import kotlinx.serialization.Serializable

@Serializable
data class TokenVerification(
    val token: String,
    val expiresAt: Instant
) {
    fun minutesToExpire(): Long {
        if (hasTokenExpired()) return 0
        val currentDate = Clock.System.now()
        val duration = expiresAt - currentDate
        return duration.inWholeMinutes
    }

    fun hasTokenExpired(): Boolean {
        val currentDate = Clock.System.now()
        return currentDate > expiresAt
    }
}