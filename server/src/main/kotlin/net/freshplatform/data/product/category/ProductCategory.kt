package net.freshplatform.data.product.category

import io.ktor.http.*
import io.ktor.server.application.*
import kotlinx.datetime.Instant
import kotlinx.serialization.Contextual
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import net.freshplatform.routes.products.categories.ProductCategoryUtils
import net.freshplatform.services.image_storage.ImageStorageServiceFactory
import net.freshplatform.utils.ErrorResponseException
import net.freshplatform.utils.InstantAsBsonDateTime
import net.freshplatform.utils.extensions.isHttpUrl
import org.bson.types.ObjectId
import org.koin.ktor.ext.inject

@Serializable
data class ProductCategoryDb(
    @SerialName("_id")
    @Contextual
    val id: ObjectId = ObjectId(),
    val name: String,
    val parentId: String?,
    val description: String,
    // TODO: I might want to allow using external image urls so I might change this variable name
    val imageNames: List<String>,
    @Serializable(with = InstantAsBsonDateTime::class)
    val createdAt: Instant,
    @Serializable(with = InstantAsBsonDateTime::class)
    val updatedAt: Instant,
) {
    fun toResponse(
        call: ApplicationCall,
    ) = ProductCategoryResponse(
        id = id.toString(),
        name = name,
        parentId = parentId,
        description = description,
        imageUrls = imageNames.map {
            if (it.isHttpUrl()) {
                return@map it
            }
            val imageStorageService by call.inject<ImageStorageServiceFactory>()
            ProductCategoryUtils.getImageStorageService(imageStorageService).getImagePublicUrl(
                fileName = it,
                request = call.request
            ).getOrElse {
                throw ErrorResponseException(
                    HttpStatusCode.InternalServerError,
                    "Unknown error while getting the image public url for category with id: $id",
                    "COULD_NOT_GET_CATEGORY_IMAGE_URL"
                )
            } ?: throw ErrorResponseException(
                HttpStatusCode.NotFound,
                "One of the image names stored in database but doesn't exist on server storage",
                "MISSING_CATEGORY_IMAGE"
            )
        },
        createdAt = createdAt,
        updatedAt = updatedAt,
    )
}

@Serializable
data class ProductCategoryResponse(
    val id: String,
    val name: String,
    /**
     * Nullable for top-level categories
     * */
    val parentId: String?,
    val description: String,
    val imageUrls: List<String>,
    // TODO: I might want to add a field `hasChildren` so we don't do a request everytime
    // we open a category in the client
    val createdAt: Instant,
    val updatedAt: Instant
)

@Serializable
data class CreateProductCategoryRequest(
    val name: String,
    val description: String,
    val parentId: String?
) {
    fun validate(): Pair<String, String>? {
        return when {
            name.isBlank() -> Pair("Category name is missing", "MISSING_CATEGORY_NAME")
            else -> null
        }
    }
}

@Serializable
data class UpdateProductCategoryRequest(
    val name: String,
    val description: String,
) {
    fun validate(): Pair<String, String>? {
        return when {
            name.isBlank() -> Pair("Category name is missing", "MISSING_CATEGORY_NAME")
            else -> null
        }
    }
}