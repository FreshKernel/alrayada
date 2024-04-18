package net.freshplatform.services.image_storage

import io.ktor.server.request.*

interface ImageStorageServiceFactory {
    fun create(storageLocation: String): ImageStorageService
}

interface ImageStorageService {
    /**
     * [storageLocation] is used to get the directory or image reference
     * in either the cloud or local storage
     * */
    val storageLocation: String

    /**
     * @param imageBytes is used to save the image
     * @param filePrefix this will be used to generate a unique yet readable file name.
     * it will be
     *
     * ```kotlin
     * val fileName = "$filePrefix-${UUID.randomUUID()}"
     * ```
     *
     * [storageLocation] is used to save the [imageBytes] either in the cloud or local file system
     * @return The generated file name
     * */
    suspend fun saveImage(
        imageBytes: ByteArray,
        filePrefix: String,
    ): Result<String>

    /**
     * @param fileName the file name in the [storageLocation]
     * */
    suspend fun deleteImage(
        fileName: String
    ): Result<Unit>

    /**
     * @param fileName the file name in the [storageLocation]
     * @param request it's required because we need it to get the server base url that is used by the client
     *
     * @return The public image url if the file exists
     * */
    fun getImagePublicUrl(
        fileName: String,
        request: ApplicationRequest
    ): Result<String?>
}