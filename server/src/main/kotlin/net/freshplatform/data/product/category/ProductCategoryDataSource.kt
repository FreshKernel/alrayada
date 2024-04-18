package net.freshplatform.data.product.category

interface ProductCategoryDataSource {
    suspend fun insertCategory(category: DbProductCategory): Boolean
    suspend fun deleteCategoryById(id: String): Boolean
    suspend fun updateCategoryById(
        id: String,
        name: String,
        description: String,
        imageNames: List<String>,
    ): Boolean
    suspend fun getCategoryById(id: String): Result<DbProductCategory?>
    suspend fun getTopLevelCategories(page: Int, limit: Int): Result<List<DbProductCategory>>
    suspend fun getChildCategories(parentId: String, page: Int, limit: Int): Result<List<DbProductCategory>>
}