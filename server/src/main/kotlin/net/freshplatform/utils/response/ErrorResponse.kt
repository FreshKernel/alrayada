package net.freshplatform.utils.response

import io.ktor.http.*
import kotlinx.serialization.Serializable

@Serializable
data class ErrorResponse(
    val message: String,
    val code: String,
    val data: Map<String, String>? = null,
)

data class ErrorResponseException(
    val status: HttpStatusCode,
    override val message: String,
    val code: String,
    val data: Map<String, String>? = null
) : Exception()

// TODO: I might use this everywhere instead of `result.getOrElse { // throw http error response  }`
fun <T> Result<T>.getOrThrowHttpError(
    status: HttpStatusCode = HttpStatusCode.InternalServerError,
    message: String,
    code: String = "UNKNOWN_ERROR",
    data: Map<String, String>? = null
): T {
    if (isFailure) {
        throw ErrorResponseException(
            status = status,
            message = message,
            code = code,
            data = data
        )
    }
    return getOrThrow()
}