package net.freshplatform.data.offer

import io.ktor.server.application.*
import kotlinx.serialization.Serializable
import net.freshplatform.utils.extensions.request.getImageClientUrl
import net.freshplatform.utils.helpers.LocalDateTimeSerializer
import org.bson.codecs.pojo.annotations.BsonId
import org.bson.types.ObjectId
import java.time.LocalDateTime

data class Offer(
    @BsonId
    val id: ObjectId = ObjectId(),
    val imageUrl: String,
    val createdAt: LocalDateTime = LocalDateTime.now()
) {
    fun stringId() = id.toString()
    fun toResponse(call: ApplicationCall) = OfferResponse(
        id = stringId(),
        imageUrl = call.getImageClientUrl(imageUrl),
        createdAt = createdAt
    )
}

@Serializable
data class OfferResponse(
    val id: String,
    val imageUrl: String,
    @Serializable(with = LocalDateTimeSerializer::class)
    val createdAt: LocalDateTime = LocalDateTime.now()
)