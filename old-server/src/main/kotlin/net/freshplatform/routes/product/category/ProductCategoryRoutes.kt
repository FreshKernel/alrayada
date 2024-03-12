package net.freshplatform.routes.product.category

import net.freshplatform.data.product.Product
import net.freshplatform.data.product.ProductDataSource
import net.freshplatform.data.product_category.ProductCategoryDataSource
import net.freshplatform.data.product_category.ProductCategoryRequest
import net.freshplatform.utils.extensions.createFile
import net.freshplatform.utils.extensions.deleteAwait
import net.freshplatform.utils.extensions.request.*
import io.ktor.http.*
import io.ktor.http.content.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.request.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import kotlinx.serialization.json.Json
import java.io.File

class ProductCategoryRoutes(
    private val router: Route,
    private val productCategoryDataSource: ProductCategoryDataSource,
    private val productDataSource: ProductDataSource
) {
    companion object {
        const val NAME = "categories"
    }
    private fun getCategoriesImagesFolder() = File(getImageFolder(), NAME)
    fun getAll() = router.get("/") {
        call.protectRouteToAppOnly()
        val responseList = productCategoryDataSource.getAll().map { parentCategory ->
            val id = parentCategory.id
            val childrenOfItem = productCategoryDataSource.getAllChildrenOf(id)
                .map { it.toResponse(null, call) }
            val response = parentCategory.toResponse(childrenOfItem, call)
            response
        }
        call.respond(HttpStatusCode.OK, responseList)
    }

    fun getAllChildrenOfParent() = router.get("/children/{id}") {
        call.protectRouteToAppOnly()
        val parent = call.requireParameterId()
        // get all children of parent
        val childrenById = productCategoryDataSource.getAllChildrenOf(parent).map { it.toResponse(null, call) }
        call.respond(HttpStatusCode.OK, childrenById)
    }

    fun getOneById() = router.get("/{id}") {
        call.protectRouteToAppOnly()
        val id = call.requireParameterId()

        // make sure the data is exists
        val productCategory = productCategoryDataSource.getOneById(id) ?: kotlin.run {
            call.respond(HttpStatusCode.Conflict, "There is no product category with that id.")
            return@get
        }

        // get the children of that data if the category is has no parent
        var responseData = productCategory.toResponse(null, call)

        if (productCategory.parent == null) {
            val childrenOfItem = productCategoryDataSource.getAllChildrenOf(id)
                .map { it.toResponse(null, call) }
            responseData = productCategory.toResponse(childrenOfItem, call)
        }
//        call.respondJsonText(HttpStatusCode.OK, File(getImageFolder(), productCategory.imageUrls.first()).path)
//        return@get
        call.respond(HttpStatusCode.OK, responseData)
    }

    fun createOne() = router.authenticate {
        post("/") {
            call.requireAdminUser()
            val multipart = call.receiveMultipart()
            var json = ""
            var file = File("")
            multipart.forEachPart { partData ->
                when (partData) {
                    is PartData.FormItem -> {
                        if (partData.name != "json") return@forEachPart
                        json = partData.value
                    }

                    is PartData.FileItem -> {
                        file = partData.createFile(File(getCategoriesImagesFolder(), partData.originalFileName!!))
                    }

                    else -> {
                        call.respondJsonText(HttpStatusCode.BadRequest, "Bad request")
                    }
                }
            }
            if (!file.exists()) {
                call.respondJsonText(HttpStatusCode.BadRequest, "File doesn't exists")
                return@post
            }
            val productCategoryRequest = Json.decodeFromString(ProductCategoryRequest.serializer(), json)

            // request body validation
            val error = productCategoryRequest.validate()
            if (error != null) {
                call.respondJsonText(HttpStatusCode.BadRequest, error)
                return@post
            }

            // if it has parent, then it should exist
            if (productCategoryRequest.parent != null) {
                val parentProductCategory = productCategoryDataSource.getOneById(productCategoryRequest.parent)
                if (parentProductCategory == null) {
                    call.respondJsonText(
                        HttpStatusCode.Conflict,
                        "The parent product category id does not exists in the database."
                    )
                    return@post
                }
            }
            // insert process && handle errors
            val productCategory = productCategoryRequest.toDatabase(
                imageUrls = listOf("/${NAME}/${file.name}")
            )
            val success = productCategoryDataSource.createOne(
                productCategory
            )
            if (!success) {
                call.respondJsonText(
                    HttpStatusCode.InternalServerError,
                    "Error while adding product category to database."
                )
                return@post
            }
            val productCategoryResponse = productCategory.toResponse(
                children = emptyList(),
                call = call
            )
            call.respond(HttpStatusCode.OK, productCategoryResponse)
        }
    }

    fun updateOne() = router.authenticate {
        put("/{id}") {
            call.requireAdminUser()
            val id = call.requireParameterId()
            val multipart = call.receiveMultipart()
            var json = ""
            var file = File("")
            multipart.forEachPart { partData ->
                when (partData) {
                    is PartData.FormItem -> {
                        if (partData.name != "json") return@forEachPart
                        json = partData.value
                    }

                    is PartData.FileItem -> {
                        file = partData.createFile(File(getCategoriesImagesFolder(), partData.originalFileName!!))
                    }

                    else -> {
                        call.respondJsonText(HttpStatusCode.BadRequest, "Bad request")
                    }
                }
            }
            val fileExists = file.exists()

            val productCategoryRequest = Json.decodeFromString(ProductCategoryRequest.serializer(), json)

            // request body validation
            val error = productCategoryRequest.validate()
            if (error != null) {
                call.respond(HttpStatusCode.BadRequest, error)
                return@put
            }

            // make sure the current data to update is exists
            val currentProductCategory = productCategoryDataSource.getOneById(id) ?: kotlin.run {
                call.respond(
                    HttpStatusCode.Conflict, "There is no product category" +
                            " with that id."
                )
                return@put
            }

            // delete the previous files
            if (fileExists) {
                currentProductCategory.imageUrls.forEach {
                    File(getImageFolder(), it).deleteAwait()
                }
            }

            // if it has parent, then it should exist
            if (productCategoryRequest.parent != null) {
                val parentProductCategory = productCategoryDataSource.getOneById(productCategoryRequest.parent)
                if (parentProductCategory == null) {
                    call.respond(
                        HttpStatusCode.Conflict,
                        "The parent product category id does not exists in the database."
                    )
                    return@put
                }
            }

            val currentFirstImageFile = File(getImageFolder(), currentProductCategory.imageUrls.first())

            // update process && handle errors
            val productCategory = productCategoryRequest.toDatabase(
                id = currentProductCategory.id,
                imageUrls = if (fileExists) listOf("/${NAME}/${file.name}") else listOf("/${NAME}/${currentFirstImageFile.name}")
            )
            val updateSuccess = productCategoryDataSource.updateOne(
                productCategory
            )
            if (!updateSuccess) {
                call.respond(
                    HttpStatusCode.InternalServerError, "Error while update" +
                            " product category."
                )
                return@put
            }
            val childrenOfItem = productCategoryDataSource.getAllChildrenOf(currentProductCategory.id)
                .map { it.toResponse(
                    children = null,
                    call = call
                ) }
            val response = productCategory.toResponse(
                children = childrenOfItem,
                call = call
            )
            call.respond(HttpStatusCode.OK, response)

        }
    }

    fun deleteOne() = router.authenticate {
        delete("/{id}") {
            call.requireAdminUser()
            val id = call.requireParameterId()

            // make sure the current data to delete is exists
            val productCategory = productCategoryDataSource.getOneById(id) ?: kotlin.run {
                call.respondJsonText(HttpStatusCode.Conflict, "There is no product category by this id.")
                return@delete
            }
            // delete images && delete sub-categories and it images
            productCategory.imageUrls.forEach {
                File(getImageFolder(), it).deleteAwait()
            }
            val childrenById = productCategoryDataSource.getAllChildrenOf(productCategory.id)
            val productsToDelete = mutableListOf<Product>()
            childrenById.forEach { subCategory ->
                productsToDelete.addAll(productDataSource.getAllByCategory(subCategory.id))
                productCategoryDataSource.deleteOneById(subCategory.id)
                subCategory.imageUrls.forEach {
                    File(getImageFolder(), it).deleteAwait()
                }
            }
            productsToDelete.addAll(productDataSource.getAllByCategory(productCategory.id))
            productsToDelete.forEach {
                // delete the products of the sub-categories and parent-category with all the images
                it.imageUrls.forEach { imageUrl ->
                    File(getImageFolder(), imageUrl).deleteAwait()
                }
                productDataSource.deleteOneById(it.id.toString())
            }
            productsToDelete.clear()
            // delete process && handle errors
            val deleteSuccess = productCategoryDataSource.deleteOneById(productCategory.id)
            if (!deleteSuccess) {
                call.respondJsonText(HttpStatusCode.InternalServerError, "Error while delete product category.")
                return@delete
            }

            call.respondJsonText(HttpStatusCode.NoContent, "Data has been successfully deleted.")
        }
    }
}
