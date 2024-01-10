package net.freshplatform.utils.extensions.request

import net.freshplatform.utils.extensions.getFileFromUserWorkingDirectory
import net.freshplatform.utils.extensions.isProductionServer
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.plugins.*
import io.ktor.server.request.*
import io.ktor.server.response.*
import kotlinx.serialization.SerializationException
import kotlinx.serialization.builtins.serializer
import kotlinx.serialization.json.Json
import net.freshplatform.services.secret_variables.SecretVariablesName
import net.freshplatform.services.secret_variables.SecretVariablesService


class RouteProtectedException: Exception("This route protected and can be accessed only by the app")

@Throws(RouteProtectedException::class)
fun ApplicationCall.protectRouteToAppOnly() {
    if (!isProductionServer()) return
    val api = this.request.header("Api") ?: ""
    if (api != SecretVariablesService.require(SecretVariablesName.ApiKey)) {
        throw RouteProtectedException()
    }
}

suspend fun ApplicationCall.respondJsonText(message: String) = respondJsonText(
    status = HttpStatusCode.BadRequest,
    text = message,
)

suspend fun ApplicationCall.respondJsonText(status: HttpStatusCode, text: String) {
    this.respondText(
        contentType = ContentType.Application.Json,
        status = status
    ) {
        try {
            Json.encodeToString(String.serializer(), text)
        } catch (e: SerializationException) {
            "Server error while return the response, please try again"
        } catch (e: Exception) {
            "Unknown server error while encode to string"
        }
    }
}

suspend inline fun <reified T : Any> ApplicationCall.receiveBodyNullableAs(): T? {
    return kotlin.runCatching { receiveNullable<T>() }.getOrNull()
}

class RequestBodyMustValidException(errorMessage: String = "Request body must valid.") : Exception(errorMessage)
class MissingParameterException(missingParameterName: String) : Exception(missingParameterName)
open class ParameterInvalidException(error: String) : Exception(error)
class ParameterMustBeIntException(parameterName: String = "\${}") :
    ParameterInvalidException("Parameter $parameterName must be int")

@Throws(RequestBodyMustValidException::class)
suspend inline fun <reified T : Any> ApplicationCall.receiveBodyAs(errorMessage: String = "Please enter a valid body"): T {
    val body = receiveBodyNullableAs<T>()
    if (body == null) {
        this.respondJsonText(HttpStatusCode.BadRequest, errorMessage)
        throw RequestBodyMustValidException(errorMessage)
    }
    return body
}

fun ApplicationCall.getServerClientUrl(): String {
    val connectionPoint = this.request.origin
    var connectionScheme = connectionPoint.scheme
    if (isProductionServer()) {
        connectionScheme = connectionScheme
            .replace("http", "https")
            .replace("ws", "wss")
    }
    var url = "${connectionScheme}://${connectionPoint.serverHost}"
    if (!isProductionServer()) {
        url += ":${connectionPoint.serverPort}" // Add port
    }
    return url
}

fun ApplicationCall.getImageFolderClientPath(): String {
    return "${getServerClientUrl()}/images"
}

fun ApplicationCall.getImageClientUrl(imageRef: String): String {
    if(imageRef.isBlank()) return ""
    if (imageRef.startsWith("http")) return imageRef // it is image url actually
    return "${getImageFolderClientPath()}$imageRef"
}

fun getImageFolder() = "/files/images/".getFileFromUserWorkingDirectory()

suspend fun ApplicationCall.requireParameter(
    parameterName: String,
    errorMessage: String = "Parameter '$parameterName' is required"
): String {
    val parameterValue = this.parameters[parameterName]
    if (parameterValue.isNullOrBlank()) {
        this.respondJsonText(HttpStatusCode.BadRequest, errorMessage)
        throw MissingParameterException(parameterName)
    }
    return parameterValue
}

fun ApplicationCall.getParameter(parameterName: String): String {
    return parameters[parameterName] ?: return ""
}

suspend fun ApplicationCall.requestPageParameter(defaultPage: Int = 1): Int {
    val page = this.getParameter("page")
    if (page.isEmpty()) return defaultPage
    val pageInt = page.toIntOrNull() ?: kotlin.run {
        this.respondJsonText(HttpStatusCode.BadRequest, "Parameter page must be valid int")
        throw ParameterMustBeIntException("page")
    }
    return pageInt
}

suspend fun ApplicationCall.requestLimitParameter(defaultLimit: Int = 10): Int {
    val limit = this.getParameter("limit")
    if (limit.isEmpty()) return defaultLimit
    val pageInt = limit.toIntOrNull() ?: kotlin.run {
        this.respondJsonText(HttpStatusCode.BadRequest, "Parameter limit must be valid int")
        throw ParameterMustBeIntException("limit")
    }
    return pageInt
}
class RequireIdException : Exception("Id is required")

@Throws(RequireIdException::class)
suspend fun ApplicationCall.requireParameterId(
    errorMessage: String = "Please enter valid id to the url"
): String {
    val parameters = this.parameters
    if (!parameters.contains("id") || parameters["id"].toString().isBlank()) {
        this.respond(HttpStatusCode.BadRequest, errorMessage)
        throw RequireIdException()
    }
    return parameters["id"].toString().trim()
}