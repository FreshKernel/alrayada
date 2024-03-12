package net.freshplatform.services.security.hashing

data class SaltedHash(
    val hash: String,
    val salt: String,
)
