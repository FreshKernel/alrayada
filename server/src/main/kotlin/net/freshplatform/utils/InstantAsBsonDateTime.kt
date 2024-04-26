package net.freshplatform.utils

import kotlinx.datetime.Instant
import kotlinx.serialization.KSerializer
import kotlinx.serialization.SerializationException
import kotlinx.serialization.descriptors.PrimitiveKind
import kotlinx.serialization.descriptors.PrimitiveSerialDescriptor
import kotlinx.serialization.descriptors.SerialDescriptor
import kotlinx.serialization.encoding.Decoder
import kotlinx.serialization.encoding.Encoder
import org.bson.BsonDateTime
import org.bson.codecs.kotlinx.BsonDecoder
import org.bson.codecs.kotlinx.BsonEncoder

/**
 * See this [link](https://www.mongodb.com/docs/drivers/kotlin/coroutine/current/fundamentals/data-formats/serialization/#custom-serializer-example)
 * The original [question](https://jira.mongodb.org/browse/JAVA-5296)
 *
 * Should be used in all the [Instant] fields from [kotlinx.datetime.Instant]
 * */
object InstantAsBsonDateTime : KSerializer<Instant> {
    override val descriptor: SerialDescriptor = PrimitiveSerialDescriptor("InstantAsBsonDateTime", PrimitiveKind.STRING)

    override fun serialize(encoder: Encoder, value: Instant) {
        when (encoder) {
            is BsonEncoder -> encoder.encodeBsonValue(BsonDateTime(value.toEpochMilliseconds()))
            else -> throw SerializationException("Instant is not supported by ${encoder::class}")
        }
    }

    override fun deserialize(decoder: Decoder): Instant {
        return when (decoder) {
            is BsonDecoder -> Instant.fromEpochMilliseconds(decoder.decodeBsonValue().asDateTime().value)
            else -> throw SerializationException("Instant is not supported by ${decoder::class}")
        }
    }
}