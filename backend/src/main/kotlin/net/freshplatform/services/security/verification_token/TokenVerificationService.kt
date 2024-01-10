package net.freshplatform.services.security.verification_token

interface TokenVerificationService {
    suspend fun generate(name: String): TokenVerification
}