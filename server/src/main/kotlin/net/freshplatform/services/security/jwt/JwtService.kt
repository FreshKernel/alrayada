package net.freshplatform.services.security.jwt

import com.auth0.jwt.JWTVerifier
import kotlin.time.Duration

interface JwtService {
    suspend fun generateAccessToken(userId: String, expiresIn: Duration): JwtValue
    val verifier: JWTVerifier
}