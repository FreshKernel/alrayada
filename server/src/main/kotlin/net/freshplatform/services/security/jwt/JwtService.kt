package net.freshplatform.services.security.jwt

import com.auth0.jwt.JWTVerifier

interface JwtService {
    suspend fun generateAccessToken(userId: String): JwtValue
    val verifier: JWTVerifier
}