package net.freshplatform.data.product.category

interface ProductCategoryDataSource {
    suspend fun insertCategory(category: ProductCategoryDb): Boolean
    suspend fun deleteCategoryById(id: String): Boolean
    suspend fun updateCategoryById(
        id: String,
        name: String,
        description: String,
        imageNames: List<String>,
    ): Boolean

    /**
     * Delete all categories by [ProductCategoryDb.parentId]
     * */
    suspend fun deleteChildCategories(parentId: String): Boolean

    suspend fun isCategoryExist(categoryId: String): Result<Boolean>

    suspend fun isCategoryHasChildren(parentId: String): Result<Boolean>

    suspend fun getCategoryById(id: String): Result<ProductCategoryDb?>
    suspend fun getCategories(
        page: Int,
        limit: Int,
        parentId: String?,
    ): Result<List<ProductCategoryDb>>

    /**
     * Get the images for all the categories by [parentId]
     * @return A list of [ProductCategoryDb] but including only [ProductCategoryDb.imageNames] field
     * */
    suspend fun getCategoryImages(parentId: String?): Result<List<List<String>>>
}