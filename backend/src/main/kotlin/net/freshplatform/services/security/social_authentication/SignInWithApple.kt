package net.freshplatform.services.security.social_authentication

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
    fun getAppleSingingKey(kid: String): PublicKey? {
        return try {
            JwkProviderBuilder("https://appleid.apple.com/auth/keys")
                .cached(10, 24, TimeUnit.MINUTES)
                .build()
                .get(kid).publicKey
        } catch (e: SigningKeyNotFoundException) {
//            println("SigningKeyNotFoundException ${e.message}")
            null
        } catch (e: NetworkException) {
//            println("NetworkException ${e.message}")
            null
        } catch (e: RateLimitReachedException) {
//            println("RateLimitReachedException ${e.message}")
            null
        } catch (e: Exception) {
            e.printStackTrace()
            println("Unhandled exception in SignInWithApple.getAppleSingingKey()")
            null
        }
    }
    fun verifyJWT(jwt: String, publicKey: PublicKey): DecodedJWT? {
        return try {
            val verifier = JWT.require(Algorithm.RSA256(publicKey as RSAPublicKey, null))
                .withIssuer("https://appleid.apple.com").build()
            verifier.verify(jwt)
        } catch (e: TokenExpiredException) {
//            print("Apple token is expired! ${e.message}")
            null
        } catch (e: JwkException) {
//            println("Failed to get JWK from provider: ${e.message}")
            null
        } catch (e: JWTVerificationException) {
//            println("Failed to verify token: ${e.message}")
            null
        } catch (e: Exception) {
            e.printStackTrace()
            println("Unhandled exception in SignInWithApple.verifyJWT()")
            null
        }
    }
}