package net.freshplatform.services.image_storage

import com.sksamuel.scrimage.ImmutableImage
import com.sksamuel.scrimage.webp.WebpWriter
import io.ktor.server.request.*
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import net.freshplatform.utils.extensions.baseUrl
import java.io.File
import java.nio.file.Paths
import java.util.*
import kotlin.io.path.pathString

class LocalImageStorageServiceFactory : ImageStorageServiceFactory {
    override fun create(storageLocation: String): ImageStorageService {
        return LocalImageStorageService(storageLocation)
    }
}

class LocalImageStorageService(
    private val directoryPath: String
) : ImageStorageService {
    override val storageLocation: String
        get() = directoryPath

    override suspend fun saveImage(imageBytes: ByteArray, filePrefix: String): Result<String> {
        return withContext(Dispatchers.IO) {
            try {
                val fileName = "$filePrefix-${UUID.randomUUID()}.webp"
                val file = File(storageLocation, fileName)
                if (!file.parentFile.exists()) {
                    file.parentFile.mkdirs()
                }
                if (file.canWrite()) {
                    throw SecurityException("Insufficient permissions to write to storage")
                }
                file.createNewFile()
//                file.writeBytes(imageBytes)
                ImmutableImage.loader().fromBytes(imageBytes).output(WebpWriter.DEFAULT, file)
                Result.success(fileName)
            } catch (e: Exception) {
                e.printStackTrace()
                Result.failure(e)
            }
        }
    }

    override suspend fun deleteImage(fileName: String): Result<Unit> {
        return try {
            val file = File(storageLocation, fileName)
            if (!file.exists()) {
                throw Exception("The file to delete $fileName doesn't exist on the local file system.")
            }
            if (!file.delete()) {
                throw Exception("Unknown error while deleting the file $fileName on the local file system.")
            }
            Result.success(Unit)
        } catch (e: Exception) {
            e.printStackTrace()
            Result.failure(e)
        }
    }

    override fun getImagePublicUrl(fileName: String, request: ApplicationRequest): Result<String?> {
        return try {
            val baseUrl = request.baseUrl()
            val filePath = Paths.get(storageLocation, fileName)
            if (!filePath.toFile().exists()) {
                return Result.success(null)
            }
            val url = "${baseUrl}/${filePath.pathString}"
            Result.success(url)
        } catch (e: Exception) {
            e.printStackTrace()
            Result.failure(e)
        }
    }
}