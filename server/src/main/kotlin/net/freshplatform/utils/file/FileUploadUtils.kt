package net.freshplatform.utils.file

import io.ktor.http.*
import io.ktor.http.content.*
import io.ktor.server.request.*
import kotlinx.serialization.json.Json
import net.freshplatform.Constants
import net.freshplatform.utils.response.ErrorResponseException
import java.io.File

class ImageData(
    val imageFileName: String,
    val imageFileBytes: ByteArray,
)

class RequestBodyWithNullableImage<T>(
    val imageData: ImageData?,
    val requestBody: T,
)

// TODO: Add support for uploading multiple files
suspend inline fun <reified T> ApplicationRequest.receiveBodyWithNullableImage(): RequestBodyWithNullableImage<T> {
    val multipartData = call.receiveMultipart()

    var imageFileName: String? = null
    var imageFileBytes: ByteArray? = null
    var requestBody: T? = null

    multipartData.forEachPart { part ->
        when (part) {
            is PartData.FileItem -> {
                if (part.contentType?.contentType != ContentType.Image.Any.contentType) {
                    throw ErrorResponseException(
                        HttpStatusCode.BadRequest,
                        "This file type `${part.contentType?.contentType}` is not allowed, only image.",
                        "FILE_MUST_BE_IMAGE"
                    )
                }
                imageFileName = part.originalFileName?.let { File(it).nameWithoutExtension }
                imageFileBytes = part.streamProvider().readBytes().also {
                    if (it.size > Constants.MAXIMUM_IMAGE_UPLOAD_SIZE) {
                        throw ErrorResponseException(
                            HttpStatusCode.BadRequest,
                            "The file size is too big, the maximum is: ${Constants.MAXIMUM_IMAGE_UPLOAD_SIZE}",
                            "FILE_SIZE_TOO_BIG"
                        )
                    }
                }
            }

            is PartData.FormItem -> {
                requestBody = Json.decodeFromString<T>(part.value)
            }

            else -> {
                throw ErrorResponseException(
                    HttpStatusCode.BadRequest,
                    "Please only upload a file and send the data in the request body",
                    "WRONG_PART_DATA"
                )
            }
        }
        part.dispose()
    }

    imageFileBytes?.let {
        return RequestBodyWithNullableImage(
            imageData = ImageData(
                imageFileBytes = it,
                imageFileName = imageFileName ?: throw ErrorResponseException(
                    HttpStatusCode.BadRequest,
                    "Please only upload a file that has a name",
                    "MISSING_FILE_NAME"
                )
            ),
            requestBody = requestBody ?: throw ErrorResponseException(
                HttpStatusCode.BadRequest,
                "The request body is required in order to processed",
                "MISSING_REQUEST_BODY_DATA"
            )
        )
    }

    return RequestBodyWithNullableImage(
        imageData = null,
        requestBody = requestBody ?: throw ErrorResponseException(
            HttpStatusCode.BadRequest,
            "The request body is required in order to processed",
            "MISSING_REQUEST_BODY_DATA"
        )
    )
}

class RequestBodyWithImage<T>(
    val imageData: ImageData,
    val requestBody: T,
)

suspend inline fun <reified T> ApplicationRequest.receiveBodyWithImage(): RequestBodyWithImage<T> {
    call.request.receiveBodyWithNullableImage<T>().also {
        return RequestBodyWithImage(
            imageData = it.imageData ?: throw ErrorResponseException(
                HttpStatusCode.BadRequest,
                "The image is required in order to processed.",
                "MISSING_IMAGE_UPLOAD"
            ),
            requestBody = it.requestBody
        )
    }
}