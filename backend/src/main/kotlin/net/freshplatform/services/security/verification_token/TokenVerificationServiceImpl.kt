package net.freshplatform.services.security.verification_token

import java.math.BigInteger
import java.security.SecureRandom

class TokenVerificationServiceImpl: TokenVerificationService {
    override suspend fun generate(name: String): TokenVerification {
        val random = SecureRandom()
        val token = BigInteger(130, random).toString(32)
        return TokenVerification(
            name = name,
            token = token,
            expiresAt = System.currentTimeMillis() + (24 * 60 * 1000L)
        )
    }
}