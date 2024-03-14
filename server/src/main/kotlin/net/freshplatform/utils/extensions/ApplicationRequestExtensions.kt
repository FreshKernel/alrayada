package net.freshplatform.utils.extensions

import io.ktor.server.plugins.*
import io.ktor.server.request.*

fun ApplicationRequest.baseUrl(): String {
    val port = call.request.port()
    val baseUrl = buildString {
        append("${call.request.origin.scheme}://${call.request.host()}")
        if (port != 80) {
            append(":${port}")
        }
    }

    return baseUrl
}