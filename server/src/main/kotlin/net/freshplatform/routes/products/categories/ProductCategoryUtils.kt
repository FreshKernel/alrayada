package net.freshplatform.routes.products.categories

import net.freshplatform.services.image_storage.ImageStorageService
import net.freshplatform.services.image_storage.ImageStorageServiceFactory
import net.freshplatform.utils.FilePaths

object ProductCategoryUtils {
    private fun getImageStorageDirectory() = FilePaths.Uploads.Products.Categories.getDirectory()
    fun getImageStorageService(
        imageStorageServiceFactory: ImageStorageServiceFactory
    ): ImageStorageService {
        return lazy {
            imageStorageServiceFactory.create(
                getImageStorageDirectory().path
            )
        }.value
    }
}