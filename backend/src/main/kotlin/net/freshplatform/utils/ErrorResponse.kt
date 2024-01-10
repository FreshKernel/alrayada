package net.freshplatform.utils

import io.ktor.http.*
import kotlinx.serialization.Serializable

@Serializable
data class ErrorResponse(val message: String, val code: String, val data: Map<String, String>?)

data class ErrorResponseException(
    val status: HttpStatusCode,
    override val message: String,
    val code: String,
    val data: Map<String, String>? = null
) : Exception()