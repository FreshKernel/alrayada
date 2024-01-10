package net.freshplatform.data.product

import net.freshplatform.data.CrudRepository

interface ProductDataSource: CrudRepository<Product, String> {
    suspend fun getBestSelling(limit: Int = 10, page: Int = 1): List<Product>
    suspend fun getAllByCategory(id: String): List<Product>
    suspend fun getByName(name: String): Product?
}