package net.freshplatform.utils.extensions

import io.ktor.http.content.*
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import java.io.File

suspend fun PartData.FileItem.createFile(file: File) = withContext(Dispatchers.IO) {
    if (!file.parentFile.exists()) {
        file.parentFile.mkdirs()
    }
    val fileName = "${System.currentTimeMillis()}.${file.extension}"
    val createdFile = File(file.parent, fileName)
    streamProvider().use { input ->
        createdFile.outputStream().buffered().use { output ->
            input.copyTo(output)
        }
    }
    createdFile
}

suspend fun File.deleteAwait() = withContext(Dispatchers.IO) {
    delete()
}