package net.freshplatform.data.product.category

import com.mongodb.client.model.Filters
import com.mongodb.client.model.Projections
import com.mongodb.client.model.Sorts
import com.mongodb.client.model.Updates
import com.mongodb.kotlin.client.coroutine.MongoDatabase
import kotlinx.coroutines.flow.singleOrNull
import kotlinx.coroutines.flow.toList
import kotlinx.datetime.Clock
import org.bson.BsonDateTime
import org.bson.Document
import org.bson.conversions.Bson
import org.bson.types.ObjectId

class MongoProductCategoryDataSource(
    database: MongoDatabase
) : ProductCategoryDataSource {
    private val categories = database.getCollection<ProductCategoryDb>("productCategories")

    override suspend fun insertCategory(category: ProductCategoryDb): Boolean {
        return try {
            categories.insertOne(
                category
            ).wasAcknowledged()
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }

    override suspend fun deleteCategoryById(id: String): Boolean {
        return try {
            categories.deleteOne(categoryIdFilter(id)).wasAcknowledged()
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }

    override suspend fun updateCategoryById(
        id: String,
        name: String,
        description: String,
        imageNames: List<String>
    ): Boolean {
        return try {
            categories.updateOne(
                categoryIdFilter(id),
                Updates.combine(
                    Updates.set(ProductCategoryDb::name.name, name),
                    Updates.set(ProductCategoryDb::description.name, description),
                    Updates.set(ProductCategoryDb::imageNames.name, imageNames),
                    setUpdatedAt()
                )
            ).wasAcknowledged()
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }

    override suspend fun deleteChildCategories(parentId: String): Boolean {
        return try {
            categories
                .deleteMany(Filters.eq(ProductCategoryDb::parentId.name, parentId))
                .wasAcknowledged()
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }

    override suspend fun isCategoryExist(categoryId: String): Result<Boolean> {
        return try {
            Result.success(
                categories.countDocuments(Filters.eq("_id", ObjectId(categoryId)))
                        > 0
            )
        } catch (e: Exception) {
            e.printStackTrace()
            Result.failure(e)
        }
    }

    override suspend fun isCategoryHasChildren(parentId: String): Result<Boolean> {
        return try {
            val value = categories.countDocuments(
                Filters.eq(ProductCategoryDb::parentId.name, parentId)
            ) > 0
            Result.success(value)
        } catch (e: Exception) {
            e.printStackTrace()
            Result.failure(e)
        }
    }

    override suspend fun getCategoryById(id: String): Result<ProductCategoryDb?> {
        return try {
            Result.success(
                categories.find(categoryIdFilter(id)).singleOrNull()
            )
        } catch (e: Exception) {
            e.printStackTrace()
            Result.failure(e)
        }
    }

    override suspend fun getCategories(page: Int, limit: Int, parentId: String?): Result<List<ProductCategoryDb>> {
        return try {
            val skip = (page - 1) * limit
            Result.success(
                categories.find(Filters.eq(ProductCategoryDb::parentId.name, parentId))
                    .sort(Sorts.descending(ProductCategoryDb::updatedAt.name))
                    .skip(skip)
                    .limit(limit)
                    .toList()
            )
        } catch (e: Exception) {
            e.printStackTrace()
            Result.failure(e)
        }
    }

    override suspend fun getCategoryImages(parentId: String?): Result<List<List<String>>> {
        return try {
            val images = categories.find<Document>(Filters.eq(ProductCategoryDb::parentId.name, parentId))
                .projection(Projections.include(ProductCategoryDb::imageNames.name, parentId))
                .toList()
                .map { it.getList(ProductCategoryDb::imageNames.name, String::class.java) }
            Result.success(images)
        } catch (e: Exception) {
            e.printStackTrace()
            Result.failure(e)
        }
    }

    private fun categoryIdFilter(categoryId: String): Bson {
        return Filters.eq("_id", ObjectId(categoryId))
    }

    private fun setUpdatedAt(): Bson {
        return Updates.set(ProductCategoryDb::updatedAt.name, BsonDateTime(Clock.System.now().toEpochMilliseconds()))
    }
}