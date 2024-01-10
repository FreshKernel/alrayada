package net.freshplatform.data

interface CrudRepository<T, Id> {
    suspend fun createOne(entity: T): Boolean
    suspend fun getOneById(id: Id): T?
    suspend fun getAll(limit: Int = 10, page: Int = 1): List<T>
    suspend fun getAllByIds(ids: List<Id>): List<T>
    suspend fun updateOne(entity: T): Boolean
    suspend fun deleteOneById(id: Id): Boolean
}