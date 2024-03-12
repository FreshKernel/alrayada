package net.freshplatform.data.product_category

import net.freshplatform.utils.extensions.request.getImageClientUrl
import net.freshplatform.utils.helpers.LocalDateTimeSerializer
import io.ktor.server.application.*
import kotlinx.serialization.Serializable
import java.time.LocalDateTime
import java.util.*

data class ProductCategory(
    val id: String,
    val name: String,
    val description: String,
    val shortDescription: String,
    val imageUrls: List<String>,
    val parent: String? = null,
    val createdAt: LocalDateTime,
) {
    fun toResponse(children: List<ProductCategoryResponse>?, call: ApplicationCall) = ProductCategoryResponse(
        id = id,
        name = name,
        description = description,
        shortDescription = shortDescription,
        imageUrls = imageUrls.map {
            call.getImageClientUrl(it)
        },
        parent = parent,
        createdAt = createdAt,
        children = children,
    )
}

@Serializable
data class ProductCategoryResponse(
    val id: String,
    val name: String,
    val description: String,
    val shortDescription: String = "",
    val imageUrls: List<String> = emptyList(),
    val parent: String?,
    @Serializable(with = LocalDateTimeSerializer::class)
    val createdAt: LocalDateTime,
    val children: List<ProductCategoryResponse>?
)

@Serializable
data class ProductCategoryRequest(
    val name: String,
    val description: String,
    val shortDescription: String,
    val parent: String? = null,
) {
    fun validate(): String? {
        return when {
            name.isBlank() -> "Name is empty"
            else -> null
        }
    }

    fun toDatabase(id: String = UUID.randomUUID().toString(), imageUrls: List<String>) = ProductCategory(
        name = name,
        description = description,
        shortDescription = shortDescription,
        imageUrls = imageUrls,
        parent = parent,
        createdAt = LocalDateTime.now(),
        id = id
    )
}