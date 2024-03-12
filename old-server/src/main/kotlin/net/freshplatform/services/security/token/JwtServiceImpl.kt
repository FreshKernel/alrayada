package net.freshplatform.services.security.token

import com.auth0.jwt.JWT
import com.auth0.jwt.algorithms.Algorithm
import java.util.*

class JwtServiceImpl : JwtService {

    override fun generate(vararg claims: TokenClaim): JwtValue {
        val tokenConfig = getTokenConfig()
        val expiresIn = tokenConfig.expiresIn
        val expiresAt = System.currentTimeMillis() + expiresIn
        val token = JWT.create()
            .withAudience(tokenConfig.audience)
            .withIssuer(tokenConfig.issuer)
            .withExpiresAt(Date(expiresAt))
        claims.forEach { claim ->
            token.withClaim(claim.name, claim.value)
        }
        return JwtValue(
            token = token.sign(Algorithm.HMAC256(tokenConfig.secret)),
            expiresAt = expiresAt,
            expiresIn = expiresIn
        )
    }

    override fun generateUserToken(userId: String): JwtValue {
        return generate(
            TokenClaim("userId", userId)
        )
    }
}