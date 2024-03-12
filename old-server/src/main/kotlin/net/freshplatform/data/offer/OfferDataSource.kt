package net.freshplatform.data.offer

interface OfferDataSource {
    suspend fun getAll(): List<Offer>
    suspend fun insertOne(offer: Offer): Boolean
    suspend fun getOneById(id: String): Offer?
    suspend fun deleteOneById(id: String): Boolean
}