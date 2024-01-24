package net.freshplatform.services.security.hashing

interface BcryptHashingService {
    suspend fun generatedSaltedHash(value: String, saltRounds: Int = 12): String
    suspend fun verify(value: String, saltedHash: String): Boolean
}