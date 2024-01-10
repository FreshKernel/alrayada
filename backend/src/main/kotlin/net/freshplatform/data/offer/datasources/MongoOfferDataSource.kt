package net.freshplatform.data.offer.datasources

import net.freshplatform.data.offer.Offer
import net.freshplatform.data.offer.OfferDataSource
import org.bson.types.ObjectId
import org.litote.kmongo.coroutine.CoroutineDatabase

class MongoOfferDataSource(
    db: CoroutineDatabase
) : OfferDataSource {
    private val offers = db.getCollection<Offer>("offers")
    override suspend fun getAll(): List<Offer> {
        return offers.find()
            .descendingSort(Offer::createdAt)
            .toList()
    }

    override suspend fun insertOne(offer: Offer): Boolean {
        return offers.insertOne(offer).wasAcknowledged()
    }

    override suspend fun getOneById(id: String): Offer? {
        return try {
            offers.findOneById(ObjectId(id))
        } catch (e: Exception) {
            null
        }
    }

    override suspend fun deleteOneById(id: String): Boolean {
        return try {
            offers.deleteOneById(ObjectId(id)).wasAcknowledged()
        } catch (e: Exception) {
            false
        }
    }
}