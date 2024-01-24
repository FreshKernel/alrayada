package net.freshplatform.plugins

import io.ktor.http.*
import io.ktor.resources.*
import io.ktor.serialization.*
import io.ktor.server.application.*
import io.ktor.server.plugins.*
import io.ktor.server.plugins.ratelimit.*
import io.ktor.server.plugins.statuspages.*
import io.ktor.server.resources.*
import io.ktor.server.resources.Resources
import io.ktor.server.response.*
import io.ktor.server.routing.*
import kotlinx.serialization.Serializable
import kotlinx.serialization.SerializationException
import net.freshplatform.routes.auth.deleteSelfAccount
import net.freshplatform.routes.auth.signInWithEmailAndPassword
import net.freshplatform.routes.auth.signUpWithEmailAndPassword
import net.freshplatform.routes.auth.verifyEmail
import net.freshplatform.utils.ErrorResponse
import net.freshplatform.utils.ErrorResponseException
import net.freshplatform.utils.extensions.AuthorizationRequiredException
import net.freshplatform.utils.getEnvironmentVariables

fun Application.configureRouting() {

    install(StatusPages) {
        if (!getEnvironmentVariables().isProductionMode) {
            exception<Throwable> { call, cause ->
                cause.printStackTrace()
                call.respond(HttpStatusCode.InternalServerError, ErrorResponse("500: $cause", "SERVER_ERROR"))
            }
        }
        exception<SerializationException> { call, cause ->
            call.respond(HttpStatusCode.BadRequest, ErrorResponse("Invalid json: $cause", "INVALID_JSON"))
        }
        exception<IllegalArgumentException> { call, cause ->
            call.respond(HttpStatusCode.BadRequest, ErrorResponse("Invalid: $cause", "INVALID_ARGUMENT"))
        }
        exception<ContentTransformationException> { call, cause ->
            call.respond(
                HttpStatusCode.BadRequest,
                ErrorResponse("Invalid request format: ${cause.message}", "INVALID_REQUEST_FORMAT")
            )
        }
        exception<BadRequestException> { call, cause ->
            call.respond(HttpStatusCode.BadRequest, ErrorResponse("Bad request: ${cause.message}", "INVALID_BODY"))
        }
        exception<NotFoundException> { call, cause ->
            call.respond(HttpStatusCode.NotFound, ErrorResponse("Not found: ${cause.message}", "NOT_FOUND"))
        }
        exception<MissingRequestParameterException> { call, cause ->
            call.respond(
                HttpStatusCode.BadRequest,
                ErrorResponse("Missing parameter: ${cause.message}", "MISSING_PARAMETER"),
            )
        }
        exception<AuthorizationRequiredException> { call, cause ->
            call.respond(
                HttpStatusCode.Unauthorized,
                ErrorResponse("You need to be authenticated to complete this action: ${cause.message}", "UNAUTHENTICATED")
            )
        }
//        exception<RouteProtectedException> { _, _ ->
//            throw ErrorResponseException(HttpStatusCode.Unauthorized, "You don't have access to this api", "ROUTE_PROTECTED")
//        }
//        exception<UserShouldAuthenticatedException> { _, cause ->
//            throw ErrorResponseException(HttpStatusCode.BadRequest, cause.message.toString(), "AUTHENTICATION_REQUIRED")
//        }
//        exception<RequestBodyMustValidException> { _, cause ->
//            throw ErrorResponseException(HttpStatusCode.BadRequest, cause.message.toString(), "INVALID_BODY")
//        }
        exception<JsonConvertException> { _, cause ->
            throw ErrorResponseException(
                HttpStatusCode.InternalServerError,
                "Error while convert json = ${cause.message}",
                "JSON_CONVERT_ERROR"
            )
        }
        exception<ErrorResponseException> { call, cause ->
            call.respond(
                message = ErrorResponse(
                    message = cause.message,
                    code = cause.code,
                    data = cause.data
                ),
                status = cause.status,
            )
        }
    }

    install(Resources)

    routing {
        get("/") {
            call.respondText("Hello, World!")
        }

        route("/api") {
            rateLimit(RateLimitName("auth")) {
                route("/auth") {
                    signUpWithEmailAndPassword()
                    signInWithEmailAndPassword()
                    verifyEmail()
                    deleteSelfAccount()
                }
            }
        }

        get<Articles> { article ->
            // Get all articles ...
            call.respond("List of articles sorted starting from ${article.sort}")
        }
    }
}

@Serializable
@Resource("/articles")
class Articles(val sort: String? = "new")
