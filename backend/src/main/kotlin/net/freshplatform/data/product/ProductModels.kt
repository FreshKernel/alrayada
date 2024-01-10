package net.freshplatform.data.product

import net.freshplatform.utils.extensions.request.getImageClientUrl
import net.freshplatform.utils.helpers.LocalDateTimeSerializer
import io.ktor.server.application.*
import kotlinx.serialization.Serializable
import org.bson.codecs.pojo.annotations.BsonId
import java.time.LocalDateTime
import java.util.*

data class Product(
    @BsonId
    val id: String,
    val name: String,
    val description: String,
    val shortDescription: String,
    val originalPrice: Double,
    val discountPercentage: Float = 0f,
    val imageUrls: List<String> = emptyList(),
    val categories: Set<String> = emptySet(),
    val createdAt: LocalDateTime,
) {
    fun toResponse(call: ApplicationCall) = ProductResponse(
        id = id,
        name = name,
        description = description,
        shortDescription = shortDescription,
        originalPrice = originalPrice,
        discountPercentage = discountPercentage,
        imageUrls = imageUrls.map { call.getImageClientUrl(it) },
        categories = categories,
        createdAt = createdAt,
    )
    fun findSalePrice() = originalPrice - (originalPrice * (discountPercentage / 100))
}

@Serializable
data class ProductResponse(
    val id: String,
    val name: String,
    val description: String,
    val shortDescription: String = "",
    val originalPrice: Double,
    val discountPercentage: Float = 0f,
    val imageUrls: List<String> = emptyList(),
    val categories: Set<String> = emptySet(),
    @Serializable(with = LocalDateTimeSerializer::class)
    val createdAt: LocalDateTime,
)

@Serializable
data class ProductRequest(
    val name: String,
    val description: String,
    val shortDescription: String,
    val originalPrice: Double,
    val discountPercentage: Float = 0f,
    val categories: Set<String>,
) {
    fun validate(): String? {
        return when {
            name.isBlank() -> "Name is empty"
//            description.isBlank() -> "Description is empty"
            discountPercentage !in 0.0..100.0 -> "Discount Percentage is not in the range"
            categories.isEmpty() -> "Product must have at least one category"
            else -> null
        }
    }
    fun toDatabase(id: String = UUID.randomUUID().toString(), imageUrls: List<String>) = Product(
        id = id,
        name = name,
        description = description,
        shortDescription = shortDescription,
        originalPrice = originalPrice,
        discountPercentage = discountPercentage,
        imageUrls = imageUrls,
        categories = categories,
        createdAt = LocalDateTime.now(),
    )
}