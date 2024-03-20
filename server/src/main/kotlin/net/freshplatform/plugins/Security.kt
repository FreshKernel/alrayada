package net.freshplatform.plugins

import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.auth.jwt.*
import io.ktor.server.plugins.ratelimit.*
import io.ktor.server.response.*
import net.freshplatform.services.security.jwt.JwtService
import net.freshplatform.utils.Constants
import net.freshplatform.utils.ErrorResponse
import org.koin.ktor.ext.inject
import kotlin.time.Duration.Companion.minutes

fun Application.configureSecurity() {
    install(RateLimit) {
        global {
            rateLimiter(limit = 100, refillPeriod = 1.minutes)
        }
        register(RateLimitName("auth")) {
            rateLimiter(limit = 20, refillPeriod = 5.minutes)
        }
    }
    val jwtService by inject<JwtService>()
    authentication {
        jwt {
            realm = Constants.JwtConfig.REALM
            verifier(
                jwtService.verifier
            )
            validate { credential ->
                if (credential.payload.audience.contains(Constants.JwtConfig.AUDIENCE)) JWTPrincipal(credential.payload) else null
            }
            challenge { _, _ ->
                call.respond(
                    HttpStatusCode.Unauthorized,
                    ErrorResponse("Token is invalid or expired.", "INVALID_TOKEN"),
                )
            }
        }
    }
}
