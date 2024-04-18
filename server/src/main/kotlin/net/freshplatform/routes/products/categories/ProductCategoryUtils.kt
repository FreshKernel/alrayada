package net.freshplatform.routes.products.categories

import io.ktor.server.application.*
import net.freshplatform.data.product.category.ProductCategoryDataSource
import net.freshplatform.data.product.category.ProductCategoryResponse
import net.freshplatform.services.image_storage.ImageStorageService
import net.freshplatform.services.image_storage.ImageStorageServiceFactory
import net.freshplatform.utils.FilePaths
import org.koin.ktor.ext.inject

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
    suspend fun getChildrenRecursively(
        parentId: String,
        call: ApplicationCall
    ): Result<List<ProductCategoryResponse>> {
        return try {
            val productCategoryDataSource by call.inject<ProductCategoryDataSource>()
            val children = productCategoryDataSource.getChildCategories(
                parentId = parentId,
                page = 0,
                limit = Int.MAX_VALUE
            ).getOrThrow()
            val response = children.map { child ->
                // The toResponse will call getChildrenRecursively() internally
                child.toResponseWithChildren(
                    call = call
                )
            }
            Result.success(response)
        } catch (e: Exception) {
            e.printStackTrace()
            Result.failure(e)
        }
    }
}