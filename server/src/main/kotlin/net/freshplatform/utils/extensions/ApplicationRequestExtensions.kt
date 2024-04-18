package net.freshplatform.utils.extensions

import io.ktor.http.*
import io.ktor.server.plugins.*
import io.ktor.server.request.*

/**
 * Get the base url that the client is using to send the request
 * I might use [URLBuilder] as alternative
 * // TODO: Decide if I need to update this or not
 *
 * See this [link](https://ktor.io/docs/server-resources.html#resource_links) for more
 * */
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

///**
// * @return The public file url (http) by the [fileRef] (path reference)
// * on the local server file system
// * */
//fun ApplicationRequest.resolvePublicFileRef(fileRef: String): String {
//    if (fileRef.startsWith("http")) {
//        // This is already public file url
//        return fileRef
//    }
//    // TODO: I might use URL class instead
//    return "${baseUrl()}/$fileRef"
//}