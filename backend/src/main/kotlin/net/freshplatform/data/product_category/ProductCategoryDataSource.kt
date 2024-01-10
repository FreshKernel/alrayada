package net.freshplatform.data.product_category

import net.freshplatform.data.CrudRepository

interface ProductCategoryDataSource: CrudRepository<ProductCategory, String> {
    suspend fun getAllChildrenOf(id: String): List<ProductCategory>
    suspend fun getByName(name: String): ProductCategory?
}