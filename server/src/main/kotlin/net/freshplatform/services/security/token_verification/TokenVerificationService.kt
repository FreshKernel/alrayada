package net.freshplatform.services.security.token_verification

import kotlin.time.Duration

interface TokenVerificationService {
    suspend fun generate(durationToExpire: Duration): TokenVerification
}