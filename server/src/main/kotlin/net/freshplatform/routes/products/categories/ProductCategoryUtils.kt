package net.freshplatform.routes.products.categories

import net.freshplatform.services.image_storage.ImageStorageService
import net.freshplatform.services.image_storage.ImageStorageServiceFactory
import net.freshplatform.utils.file.FilePaths

object ProductCategoryUtils {
    fun getImageStorageService(
        imageStorageServiceFactory: ImageStorageServiceFactory
    ): ImageStorageService {
        return lazy {
            imageStorageServiceFactory.create(
                FilePaths.Uploads.Products.Categories.getDirectory().path
            )
        }.value
    }
}