package net.freshplatform.plugins

import io.github.smiley4.ktorswaggerui.SwaggerUI
import io.ktor.http.*
import io.ktor.serialization.*
import io.ktor.server.application.*
import io.ktor.server.plugins.*
import io.ktor.server.plugins.ratelimit.*
import io.ktor.server.plugins.statuspages.*
import io.ktor.server.resources.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import kotlinx.serialization.SerializationException
import net.freshplatform.routes.user.userRoutes
import net.freshplatform.routes.live_chat.liveChatRoutes
import net.freshplatform.utils.ErrorResponse
import net.freshplatform.utils.ErrorResponseException
import net.freshplatform.utils.getEnvironmentVariables

fun Application.configureRouting() {

    install(StatusPages) {
        status(HttpStatusCode.NotFound) { call, status ->
            call.respondText(text = "404: Page Not Found", status = status)
        }
        exception<Throwable> { call, cause ->
            cause.printStackTrace()
            if (getEnvironmentVariables().isProductionMode) {
                call.respond(
                    HttpStatusCode.InternalServerError,
                    ErrorResponse("Unknown server error", "UNKNOWN_SERVER_ERROR")
                )
            } else {
                call.respond(HttpStatusCode.InternalServerError, ErrorResponse("500: $cause", "UNKNOWN_SERVER_ERROR"))
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

    if (!getEnvironmentVariables().isProductionMode) {
        install(SwaggerUI) {
            ignoredRouteSelectors += RateLimitRouteSelector::class
            swagger {
                swaggerUrl = "swagger-ui"
                forwardRoot = true
            }
        }
    }

    routing {
        get("/") {
            call.respondText("Welcome, to our api!")
        }

        userRoutes()
        liveChatRoutes()
    }
}
