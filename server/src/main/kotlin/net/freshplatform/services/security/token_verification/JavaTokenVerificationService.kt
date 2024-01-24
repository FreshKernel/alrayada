package net.freshplatform.services.security.token_verification

import kotlinx.datetime.Clock
import java.math.BigInteger
import java.security.SecureRandom
import kotlin.time.Duration

class JavaTokenVerificationService : TokenVerificationService {
    override suspend fun generate(durationToExpire: Duration): TokenVerification {
        val token = BigInteger(130, SecureRandom()).toString(32)
        return TokenVerification(
            token = token,
            expiresAt = Clock.System.now().plus(durationToExpire)
        )
    }
}