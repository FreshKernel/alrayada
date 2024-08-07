package net.freshplatform.services.security.token_verification

import kotlinx.datetime.Clock
import kotlinx.datetime.Instant
import kotlinx.serialization.Serializable
import net.freshplatform.utils.serialization.InstantAsBsonDateTime

@Serializable
data class TokenVerification(
    val token: String,
    @Serializable(with = InstantAsBsonDateTime::class)
    val expiresAt: Instant,
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