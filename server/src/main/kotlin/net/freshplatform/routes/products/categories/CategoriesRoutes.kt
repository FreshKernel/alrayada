package net.freshplatform.routes.products.categories

import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import io.ktor.server.util.*
import kotlinx.datetime.Clock
import net.freshplatform.data.product.category.CreateProductCategoryRequest
import net.freshplatform.data.product.category.ProductCategoryDataSource
import net.freshplatform.data.product.category.ProductCategoryDb
import net.freshplatform.data.product.category.UpdateProductCategoryRequest
import net.freshplatform.services.image_storage.ImageStorageServiceFactory
import net.freshplatform.utils.ErrorResponseException
import net.freshplatform.utils.extensions.requireCurrentAdminUser
import net.freshplatform.utils.receiveBodyWithImage
import net.freshplatform.utils.receiveBodyWithNullableImage
import org.koin.ktor.ext.inject

fun Route.productCategoriesRoutes() {
    route("/categories") {
        authenticate {
            // For admin only routes
            createCategory()
            updateCategoryById()
            deleteCategoryById()
        }
        getTopLevelCategories()
        getChildCategoriesByParentId()
        getCategoryById()
    }
}

private fun Route.createCategory() {
    val productCategoryDataSource by inject<ProductCategoryDataSource>()
    val imageStorageService = ProductCategoryUtils.getImageStorageService(inject<ImageStorageServiceFactory>().value)

    post {
        call.requireCurrentAdminUser()
        val requestBodyWithImage = call.request.receiveBodyWithImage<CreateProductCategoryRequest>()
        val requestBody = requestBodyWithImage.requestBody

        val error = requestBody.validate()
        if (error != null) {
            throw ErrorResponseException(HttpStatusCode.BadRequest, error.first, error.second)
        }

        // If the new category to create has a parent then it should exist
        if (requestBody.parentId != null) {
            val isParentCategoryExist = productCategoryDataSource.isCategoryExist(requestBody.parentId).getOrElse {
                throw ErrorResponseException(
                    HttpStatusCode.InternalServerError,
                    "Unknown error while getting category by id when validating the parent of this category",
                    "COULD_NOT_GET_CATEGORY"
                )
            }
            if (!isParentCategoryExist) {
                throw ErrorResponseException(
                    HttpStatusCode.NotFound,
                    "The parent category for this category to create doesn't exist",
                    "PARENT_CATEGORY_NOT_FOUND"
                )
            }
        }

        val imageName = imageStorageService.saveImage(
            filePrefix = requestBodyWithImage.imageData.imageName,
            imageBytes = requestBodyWithImage.imageData.imageBytes,
        ).getOrElse {
            throw ErrorResponseException(
                HttpStatusCode.InternalServerError,
                "Unknown error while saving the category image",
                "COULD_NOT_SAVE_CATEGORY_IMAGE"
            )
        }

        val category = ProductCategoryDb(
            name = requestBody.name,
            parentId = requestBody.parentId,
            description = requestBody.description,
            imageNames = listOf(imageName),
            createdAt = Clock.System.now(),
            updatedAt = Clock.System.now(),
        )

        val isSuccess = productCategoryDataSource.insertCategory(category)

        if (!isSuccess) {
            throw ErrorResponseException(
                HttpStatusCode.InternalServerError,
                "Unknown error while inserting the category to the database.",
                "COULD_NOT_INSERT_TO_DATABASE"
            )
        }

        call.respond(
            category.toResponse(
                call = call,
            )
        )
    }
}

private fun Route.updateCategoryById() {
    val productCategoryDataSource by inject<ProductCategoryDataSource>()
    val imageStorageService = ProductCategoryUtils.getImageStorageService(inject<ImageStorageServiceFactory>().value)

    put("/{id}") {
        call.requireCurrentAdminUser()
        val id: String by call.parameters
        val requestBodyWithImage = call.request.receiveBodyWithNullableImage<UpdateProductCategoryRequest>()
        val requestBody = requestBodyWithImage.requestBody
        val imageData = requestBodyWithImage.imageData

        val error = requestBody.validate()
        if (error != null) {
            throw ErrorResponseException(
                HttpStatusCode.BadRequest, error.first, error.second
            )
        }

        val currentCategory = productCategoryDataSource.getCategoryById(id).getOrElse {
            throw ErrorResponseException(
                HttpStatusCode.InternalServerError,
                "Unknown error while getting category by id: $id",
                "COULD_NOT_GET_CATEGORY",
            )
        } ?: throw ErrorResponseException(
            HttpStatusCode.BadRequest,
            "There is no category with id: $id",
            "CATEGORY_NOT_FOUND",
        )

        var newImageName: String? = null

        // If user want to upload a new image then we will remove the old images
        if (imageData != null) {
            currentCategory.imageNames.forEach {
                imageStorageService.deleteImage(it)
            }
            newImageName = imageStorageService.saveImage(
                filePrefix = requestBodyWithImage.imageData.imageName,
                imageBytes = requestBodyWithImage.imageData.imageBytes,
            ).getOrElse {
                throw ErrorResponseException(
                    HttpStatusCode.InternalServerError,
                    "Unknown error while saving the new category image",
                    "COULD_NOT_SAVE_CATEGORY_IMAGE"
                )
            }
        }

        val newImageNames = if (newImageName != null) listOf(newImageName) else currentCategory.imageNames

        val isUpdateSuccess = productCategoryDataSource.updateCategoryById(
            id = id,
            name = requestBody.name,
            description = requestBody.description,
            imageNames = newImageNames
        )

        if (!isUpdateSuccess) {
            throw ErrorResponseException(
                HttpStatusCode.InternalServerError,
                "Unknown error while updating the category in the database",
                "COULD_NOT_UPDATE_CATEGORY",
            )
        }

        // TODO: I might change this
        val newCategory = currentCategory.copy(
            name = requestBody.name,
            description = requestBody.description,
            imageNames = newImageNames,
            updatedAt = Clock.System.now(),
        )

        val response = newCategory.toResponse(
            call = call,
        )

        call.respond(response)
    }
}

private fun Route.deleteCategoryById() {
    val productCategoryDataSource by inject<ProductCategoryDataSource>()
    val imageStorageService = ProductCategoryUtils.getImageStorageService(inject<ImageStorageServiceFactory>().value)

    delete("/{id}") {
        call.requireCurrentAdminUser()
        val id: String by call.parameters

        val category = productCategoryDataSource.getCategoryById(id).getOrElse {
            throw ErrorResponseException(
                HttpStatusCode.InternalServerError,
                "Unknown error while getting the category with id: $id",
                "COULD_NOT_GET_CATEGORY"
            )
        } ?: throw ErrorResponseException(
            HttpStatusCode.NotFound,
            "There is no category with this id: $id",
            "CATEGORY_NOT_FOUND"
        )

        // First we need to delete everything that is related
        // to that category then we will remove the category

        // 1. Delete the child-categories of that category

        productCategoryDataSource.getChildCategoryImages(
            parentId = category.id.toString(),
        ).getOrElse {
            throw ErrorResponseException(
                HttpStatusCode.InternalServerError,
                "Unknown error while getting the images of sub-categories of this category ${id}: ${it.message}",
                "COULD_NOT_GET_SUB_CATEGORIES_IMAGES"
            )
        }.forEach { images ->
            images.forEach { image ->
                imageStorageService.deleteImage(image).getOrElse { exception ->
                    throw ErrorResponseException(
                        HttpStatusCode.InternalServerError,
                        "Unknown error while deleting an image of a sub category: ${exception.message}",
                        "COULD_NOT_DELETE_SUB_CATEGORY_IMAGE"
                    )
                }
            }
        }

        val isDeleteSubCategoriesSuccess = productCategoryDataSource.deleteChildCategories(
            parentId = category.id.toString()
        )

        if (!isDeleteSubCategoriesSuccess) {
            throw ErrorResponseException(
                HttpStatusCode.InternalServerError,
                "Unknown error while deleting categories with parent id: ${category.id}",
                "COULD_NOT_DELETE_SUB_CATEGORIES"
            )
        }

        // 2. Delete the products of the category && sub-categories

        // TODO: Do it when you complete the products feature

        // 3. Remove the category itself

        category.imageNames.forEach {
            imageStorageService.deleteImage(it).getOrElse { exception ->
                throw ErrorResponseException(
                    HttpStatusCode.InternalServerError,
                    "Unknown error while deleting the image `$it` for this category: ${exception.message}",
                    "COULD_NOT_DELETE_CATEGORY_IMAGES"
                )
            }
        }

        val isDeleteSuccess = productCategoryDataSource.deleteCategoryById(category.id.toString())
        if (!isDeleteSuccess) {
            throw ErrorResponseException(
                HttpStatusCode.InternalServerError,
                "Unknown error while deleting this category",
                "COULD_NOT_DELETE_CATEGORY"
            )
        }

        call.respondText(status = HttpStatusCode.NoContent) {
            "We have successfully deleted the category."
        }
    }
}

private fun Route.getTopLevelCategories() {
    val productCategoryDataSource by inject<ProductCategoryDataSource>()

    get("/topLevel") {
        val page: Int by call.request.queryParameters
        val limit: Int by call.request.queryParameters

        val categories = productCategoryDataSource.getTopLevelCategories(page, limit).getOrElse {
            throw ErrorResponseException(
                HttpStatusCode.InternalServerError,
                "Unknown error while loading the categories",
                "COULD_NOT_LOAD_CATEGORIES"
            )
        }.map {
            it.toResponse(
                call = call,
            )
        }
        call.respond(categories)
    }
}

private fun Route.getChildCategoriesByParentId() {
    val productCategoryDataSource by inject<ProductCategoryDataSource>()

    get("/{id}/children") {
        val id: String by call.parameters
        val page: Int by call.request.queryParameters
        val limit: Int by call.request.queryParameters

        val categories = productCategoryDataSource.getChildCategoriesByParentId(id, page, limit).getOrElse {
            throw ErrorResponseException(
                HttpStatusCode.InternalServerError,
                "Unknown error while loading the categories",
                "COULD_NOT_LOAD_CATEGORIES"
            )
        }.map {
            it.toResponse(
                call = call,
            )
        }
        call.respond(categories)
    }
}

private fun Route.getCategoryById() {
    val productCategoryDataSource by inject<ProductCategoryDataSource>()

    get("/{id}") {
        val id: String by call.parameters
        val category = productCategoryDataSource.getCategoryById(id).getOrElse {
            throw ErrorResponseException(
                HttpStatusCode.InternalServerError,
                "Unknown error while getting the category with id $id: ${it.message}",
                "COULD_NOT_GET_CATEGORY"
            )
        } ?: throw ErrorResponseException(
            HttpStatusCode.NotFound,
            "There is no category with this id: $id",
            "CATEGORY_NOT_FOUND"
        )
        val response = category.toResponse(
            call = call,
        )

        call.respond(response)
    }
}