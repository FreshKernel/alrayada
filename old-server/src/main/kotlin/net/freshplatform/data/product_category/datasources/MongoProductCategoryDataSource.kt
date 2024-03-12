package net.freshplatform.data.product_category.datasources

import net.freshplatform.data.product_category.ProductCategory
import net.freshplatform.data.product_category.ProductCategoryDataSource
import org.litote.kmongo.combine
import org.litote.kmongo.coroutine.CoroutineDatabase
import org.litote.kmongo.eq
import org.litote.kmongo.setValue
import java.util.*

class MongoProductCategoryDataSource(
    db: CoroutineDatabase
): ProductCategoryDataSource {
    private val categories = db.getCollection<ProductCategory>("categories")

    /**
     * Get all parents
     * */
    override suspend fun getAll(limit: Int, page: Int): List<ProductCategory> {
        return categories.find(ProductCategory::parent eq null)
            .descendingSort(ProductCategory::createdAt)
            .toList()
    }

    override suspend fun getAllByIds(ids: List<String>): List<ProductCategory> {
        throw NotImplementedError()
    }

    override suspend fun getAllChildrenOf(id: String): List<ProductCategory> {
        return categories.find(ProductCategory::parent eq id)
            .descendingSort(ProductCategory::createdAt)
            .toList()
    }

    override suspend fun getOneById(id: String): ProductCategory? {
        return try {
            categories.findOne(
                ProductCategory::id eq id
            )
        } catch (e: Exception) {
            null
        }
    }

    override suspend fun getByName(name: String): ProductCategory? {
        return categories.findOne(ProductCategory::name eq name)
    }

    override suspend fun updateOne(entity: ProductCategory): Boolean {
        return try {
            categories.updateOne(
                filter = ProductCategory::id eq entity.id,
                update = combine(
                    setValue(ProductCategory::name, entity.name),
                    setValue(ProductCategory::description, entity.description),
                    setValue(ProductCategory::shortDescription, entity.shortDescription),
                    setValue(ProductCategory::imageUrls, entity.imageUrls),
                    setValue(ProductCategory::parent, entity.parent),
                )
            ).wasAcknowledged()
        } catch (e: Exception) {
            false
        }
    }

    override suspend fun deleteOneById(id: String): Boolean {
        return try {
            categories
                .deleteOne(ProductCategory::id eq id)
                .wasAcknowledged()
        } catch (e: Exception) {
            false
        }
    }

    override suspend fun createOne(entity: ProductCategory): Boolean {
        var id = entity.id
        while (true) {
            val exists = getOneById(id) != null
            if (!exists) {
                break
            }
            id = UUID.randomUUID().toString()
        }
        return categories.insertOne(entity).wasAcknowledged()
    }
}