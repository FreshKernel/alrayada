package net.freshplatform.data.product

import kotlinx.datetime.Instant
import kotlinx.serialization.Contextual
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import net.freshplatform.data.product.category.DbProductCategory
import net.freshplatform.utils.InstantAsBsonDateTime
import org.bson.types.ObjectId

@Serializable
data class DbProduct(
    @SerialName("_id")
    @Contextual
    val id: ObjectId = ObjectId(),
    val name: String,
    val description: String,
    val originalPrice: Double,
    val discountPercentage: Float,
    val imageRefs: List<String>,
    /**
     * Each id is the same as [DbProductCategory.id]
     * */
    val categoryIds: Set<String>,
    @Serializable(with = InstantAsBsonDateTime::class)
    val createdAt: Instant,
    @Serializable(with = InstantAsBsonDateTime::class)
    val updatedAt: Instant
)