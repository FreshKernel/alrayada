package net.freshplatform.data.product.category

import com.mongodb.client.model.Filters
import com.mongodb.client.model.Sorts
import com.mongodb.client.model.Updates
import com.mongodb.kotlin.client.coroutine.MongoDatabase
import kotlinx.coroutines.flow.singleOrNull
import kotlinx.coroutines.flow.toList
import kotlinx.datetime.Clock
import org.bson.BsonDateTime
import org.bson.conversions.Bson
import org.bson.types.ObjectId

class MongoProductCategoryDataSource(
    database: MongoDatabase
) : ProductCategoryDataSource {
    private val categories = database.getCollection<DbProductCategory>("productCategories")

    override suspend fun insertCategory(category: DbProductCategory): Boolean {
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
                    Updates.set(DbProductCategory::name.name, name),
                    Updates.set(DbProductCategory::description.name, description),
                    Updates.set(DbProductCategory::imageNames.name, imageNames),
                    setUpdatedAt()
                )
            ).wasAcknowledged()
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }

    override suspend fun getCategoryById(id: String): Result<DbProductCategory?> {
        return try {
            Result.success(
                categories.find(categoryIdFilter(id)).singleOrNull()
            )
        } catch (e: Exception) {
            e.printStackTrace()
            Result.failure(e)
        }
    }

    override suspend fun getTopLevelCategories(page: Int, limit: Int): Result<List<DbProductCategory>> {
        return try {
            val skip = (page - 1) * limit
            Result.success(
                categories.find(Filters.eq(DbProductCategory::parentId.name, null))
                    .sort(Sorts.descending(DbProductCategory::updatedAt.name))
                    .skip(skip)
                    .limit(limit)
                    .toList()
            )
        } catch (e: Exception) {
            e.printStackTrace()
            Result.failure(e)
        }
    }

    override suspend fun getChildCategories(parentId: String, page: Int, limit: Int): Result<List<DbProductCategory>> {
        return try {
            val skip = (page - 1) * limit
            Result.success(
                categories.find(Filters.eq(DbProductCategory::parentId.name, parentId))
                    .sort(Sorts.descending(DbProductCategory::updatedAt.name))
                    .skip(skip)
                    .limit(limit)
                    .toList()
            )
        } catch (e: Exception) {
            e.printStackTrace()
            Result.failure(e)
        }
    }

    private fun categoryIdFilter(categoryId: String): Bson {
        return Filters.eq("_id", ObjectId(categoryId))
    }

    private fun setUpdatedAt(): Bson {
        return Updates.set(DbProductCategory::updatedAt.name, BsonDateTime(Clock.System.now().toEpochMilliseconds()))
    }
}