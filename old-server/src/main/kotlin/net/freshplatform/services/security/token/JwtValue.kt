package net.freshplatform.services.security.token

data class JwtValue(
    val token: String,
    val expiresAt: Long,
    val expiresIn: Long,
)