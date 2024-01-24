package net.freshplatform.services.security.jwt

import kotlinx.datetime.Instant
import kotlin.time.Duration

data class JwtValue(
    val token: String,
    val expiresAt: Instant,
    val expiresIn: Duration,
)
