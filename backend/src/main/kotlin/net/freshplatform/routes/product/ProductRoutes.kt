package net.freshplatform.routes.product

import net.freshplatform.data.product.ProductDataSource
import net.freshplatform.data.product.ProductRequest
import net.freshplatform.data.product_category.ProductCategoryDataSource
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

class ProductRoutes(
    private val router: Route,
    private val productDataSource: ProductDataSource,
    private val productCategoryDataSource: ProductCategoryDataSource
) {
    companion object {
        const val NAME = "products"
    }

    private fun getProductsImagesFolder() = File(getImageFolder(), NAME)
    fun getAll() = router.get("/") {

        call.protectRouteToAppOnly()

        val limit = call.requestLimitParameter(50)
        val page = call.requestPageParameter(1)
//        val ids = call.parameters["ids"]?.split(",") ?: emptyList()
        val ids = call.receiveBodyNullableAs<List<String>>() ?: emptyList()
        if (ids.isNotEmpty()) {
            val response = productDataSource.getAllByIds(ids).map { it.toResponse(call) }
            call.respond(HttpStatusCode.OK, response)
            return@get
        }

        val response = productDataSource.getAll(limit, page).map { it.toResponse(call) }
        call.respond(HttpStatusCode.OK, response)
    }

    fun getBestSelling() = router.get("/bestSelling") {
        call.protectRouteToAppOnly()
        val limit = call.requestLimitParameter(50)
        val page = call.requestPageParameter(1)
        val products = productDataSource.getBestSelling(
            limit, page
        ).map { it.toResponse(call) }
        call.respond(HttpStatusCode.OK, products)
    }

    fun getOneById() = router.get("/{id}") {
        call.protectRouteToAppOnly()
        val id = call.requireParameterId()

        val product = productDataSource.getOneById(id) ?: kotlin.run {
            call.respondJsonText(HttpStatusCode.NotFound, "There is no product with that id.")
            return@get
        }
        call.respond(HttpStatusCode.OK, product.toResponse(call))
    }

    fun getAllByCategory() = router.get("/byCategory/{id}") {
        call.protectRouteToAppOnly()
        val id = call.requireParameterId()

        val products = productDataSource.getAllByCategory(id)
        val response = products.map { it.toResponse(call) }
        call.respond(HttpStatusCode.OK, response)
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
                        file = partData.createFile(File(getProductsImagesFolder(), partData.originalFileName!!))
                    }

                    else -> {
                        call.respondJsonText(HttpStatusCode.BadRequest, "Bad request")
                    }
                }
            }
            val fileExists = file.exists()
//            if (!file.exists()) {
//                call.respondJsonText(HttpStatusCode.BadRequest, "File doesn't exists")
//                return@post
//            }

            val productRequest = Json.decodeFromString(ProductRequest.serializer(), json)
            val error = productRequest.validate()
            if (error != null) {
                call.respond(HttpStatusCode.BadRequest, error)
                return@post
            }
            val isAnyCategoryNull = productRequest.categories.any {
                productCategoryDataSource.getOneById(it) == null
            }
            if (isAnyCategoryNull) {
                call.respond(HttpStatusCode.Conflict, "All categories must exists.")
                return@post
            }

            val product =
                productRequest.toDatabase(imageUrls = if (fileExists) listOf("/${NAME}/${file.name}") else emptyList())
            val success = productDataSource.createOne(
                product
            )
            if (!success) {
                call.respond(HttpStatusCode.InternalServerError, "Error while adding the product")
                return@post
            }
            val productResponse = product.toResponse(call)
            call.respond(HttpStatusCode.OK, productResponse)
        }
    }

    fun deleteOne() = router.authenticate {
        delete("/{id}") {
            call.requireAdminUser()
            val id = call.requireParameterId()

            // make sure the current data to delete is exists
            val product = productDataSource.getOneById(id) ?: kotlin.run {
                call.respond(
                    HttpStatusCode.Conflict, "There is no product" +
                            " with that id."
                )
                return@delete
            }

            // delete the previous files
            product.imageUrls.forEach {
                File(getImageFolder(), it).deleteAwait()
            }

            val deleteSuccess = productDataSource.deleteOneById(id)
            if (!deleteSuccess) {
                call.respond(
                    HttpStatusCode.InternalServerError, "Server error while delete" +
                            " the product."
                )
                return@delete
            }
            call.respond(HttpStatusCode.NoContent, "Product has been successfully deleted.")
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
                        file = partData.createFile(File(getProductsImagesFolder(), partData.originalFileName!!))
                    }

                    else -> {
                        call.respondJsonText(HttpStatusCode.BadRequest, "Bad request")
                    }
                }
            }
            val fileExists = file.exists()

            val productRequest = Json.decodeFromString(ProductRequest.serializer(), json)

            // request body validation
            val error = productRequest.validate()
            if (error != null) {
                call.respond(HttpStatusCode.BadRequest, error)
                return@put
            }

            // make sure the current data to update is exists
            val currentProduct = productDataSource.getOneById(id) ?: kotlin.run {
                call.respond(
                    HttpStatusCode.Conflict, "There is no product" +
                            " with that id."
                )
                return@put
            }

            // delete the previous files if new file uploaded
            if (fileExists) {
                currentProduct.imageUrls.forEach {
                    File(getImageFolder(), it).deleteAwait()
                }
            }

            val isAnyCategoryNull = productRequest.categories.any {
                productCategoryDataSource.getOneById(it) == null
            }
            if (isAnyCategoryNull) {
                call.respond(HttpStatusCode.Conflict, "All categories must exists.")
                return@put
            }

            var currentFirstImageFile: File? = null
            if (currentProduct.imageUrls.isNotEmpty()) {
                currentFirstImageFile = File(getImageFolder(), currentProduct.imageUrls.first())
            }
            val product = productRequest.toDatabase(
                id = currentProduct.id,
                imageUrls = if (fileExists) listOf("/${NAME}/${file.name}") else (
                        if (currentFirstImageFile == null) listOf() else listOf("/${NAME}/${currentFirstImageFile.name}")
                        ),
            )

            val updateSuccess = productDataSource.updateOne(
                product
            )
            if (!updateSuccess) {
                call.respond(HttpStatusCode.InternalServerError, "Error while update the product.")
                return@put
            }
            val response = product.toResponse(call)
            call.respond(HttpStatusCode.OK, response)
        }
    }
}