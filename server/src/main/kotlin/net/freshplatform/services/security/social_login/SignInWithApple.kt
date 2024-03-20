package net.freshplatform.services.security.social_login

import com.auth0.jwk.*
import com.auth0.jwt.JWT
import com.auth0.jwt.algorithms.Algorithm
import com.auth0.jwt.exceptions.JWTVerificationException
import com.auth0.jwt.exceptions.TokenExpiredException
import com.auth0.jwt.interfaces.DecodedJWT
import java.security.PublicKey
import java.security.interfaces.RSAPublicKey
import java.util.concurrent.TimeUnit

object SignInWithApple {
    fun getAppleSingingKey(kid: String): Result<PublicKey> {
        return try {
            Result.success(JwkProviderBuilder("https://appleid.apple.com/auth/keys")
                .cached(10, 24, TimeUnit.MINUTES)
                .build()
                .get(kid).publicKey)
        } catch (e: SigningKeyNotFoundException) {
            e.printStackTrace()
            Result.failure(e)
        } catch (e: NetworkException) {
            e.printStackTrace()
            Result.failure(e)
        } catch (e: RateLimitReachedException) {
            e.printStackTrace()
            Result.failure(e)
        } catch (e: Exception) {
            e.printStackTrace()
            Result.failure(e)
        }
    }
    fun verifyJWT(jwt: String, publicKey: PublicKey): Result<DecodedJWT?> {
        return try {
            val verifier = JWT.require(Algorithm.RSA256(publicKey as RSAPublicKey, null))
                .withIssuer("https://appleid.apple.com").build()
            Result.success(verifier.verify(jwt))
        } catch (e: TokenExpiredException) {
            e.printStackTrace()
            Result.success(null)
        } catch (e: JwkException) {
            e.printStackTrace()
            Result.failure(e)
        } catch (e: JWTVerificationException) {
            e.printStackTrace()
            Result.failure(e)
        } catch (e: Exception) {
            e.printStackTrace()
            Result.failure(e)
        }
    }
}