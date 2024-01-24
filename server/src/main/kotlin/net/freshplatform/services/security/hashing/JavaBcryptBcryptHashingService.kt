package net.freshplatform.services.security.hashing

import at.favre.lib.crypto.bcrypt.BCrypt
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

class JavaBcryptBcryptHashingService : BcryptHashingService {
    override suspend fun generatedSaltedHash(value: String, saltRounds: Int): String {
        return withContext(Dispatchers.IO) {
            BCrypt.withDefaults().hashToString(saltRounds, value.toCharArray())
        }
    }

    override suspend fun verify(value: String, saltedHash: String): Boolean {
        return withContext(Dispatchers.IO) {
            BCrypt.verifyer().verify(value.toCharArray(), saltedHash).verified
        }
    }
}