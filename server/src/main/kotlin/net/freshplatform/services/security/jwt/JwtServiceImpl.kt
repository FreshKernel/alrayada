package net.freshplatform.services.security.jwt

import com.auth0.jwt.JWT
import com.auth0.jwt.JWTVerifier
import com.auth0.jwt.algorithms.Algorithm
import kotlinx.datetime.Clock
import kotlinx.datetime.toJavaInstant
import net.freshplatform.utils.Constants
import net.freshplatform.utils.getEnvironmentVariables
import kotlin.time.Duration

class JwtServiceImpl : JwtService {
    override suspend fun generateAccessToken(userId: String, expiresIn: Duration): JwtValue {
        val expiresAt = Clock.System.now().plus(expiresIn)
        val token = JWT.create()
            .withIssuer(Constants.JwtConfig.ISSUER)
            .withAudience(Constants.JwtConfig.AUDIENCE)
            .withExpiresAt(expiresAt.toJavaInstant())
            .withSubject(userId)
            .sign(Algorithm.HMAC256(getEnvironmentVariables().accessTokenSecret))

        return JwtValue(
            token = token,
            expiresAt = expiresAt,
            expiresIn = expiresIn,
        )
    }

    override val verifier: JWTVerifier
        get() = JWT
            .require(Algorithm.HMAC256(getEnvironmentVariables().accessTokenSecret))
            .withAudience(Constants.JwtConfig.AUDIENCE)
            .withIssuer(Constants.JwtConfig.ISSUER)
            .build()
}