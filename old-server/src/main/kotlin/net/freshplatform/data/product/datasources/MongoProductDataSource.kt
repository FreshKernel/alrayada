package net.freshplatform.data.product.datasources

import net.freshplatform.data.order.OrderDataSource
import net.freshplatform.data.product.Product
import net.freshplatform.data.product.ProductDataSource
import org.litote.kmongo.combine
import org.litote.kmongo.coroutine.CoroutineDatabase
import org.litote.kmongo.eq
import org.litote.kmongo.`in`
import org.litote.kmongo.setValue
import java.util.*

class MongoProductDataSource(
    db: CoroutineDatabase,
    private val orderDataSource: OrderDataSource
): ProductDataSource {
    private val products = db.getCollection<Product>("products")

    override suspend fun getAll(limit: Int, page: Int): List<Product> {
        val skip = (page - 1) * limit
        return products.find()
            .descendingSort(Product::createdAt)
            .skip(skip)
            .limit(limit)
            .toList()
    }

    override suspend fun getBestSelling(limit: Int, page: Int): List<Product> {
        val orders = orderDataSource.getAll(limit, page)
        val productCount = mutableMapOf<String, Int>()
        orders.forEach { order ->
            order.items.forEach { orderItem ->
                val productId = orderItem.productId
                val count = productCount.getOrDefault(productId, 0) + orderItem.quantity
                productCount[productId] = count
            }
        }

        val sortedNonProducts = productCount.toList().sortedByDescending { (_, count) -> count }
        val ids = sortedNonProducts.map { it.first }.toList()
        return getAllByIds(ids).sortedBy { product -> ids.indexOf(product.id) }
    }

    override suspend fun getAllByCategory(id: String): List<Product> {
        return products.find(Product::categories `in` id)
            .descendingSort(Product::createdAt)
            .toList()
    }

    override suspend fun getOneById(id: String): Product? {
        return try {
            products.findOne(Product::id eq id)
        } catch (e: Exception) {
            null
        }
    }

    override suspend fun getAllByIds(ids: List<String>): List<Product> {
        return try {
            products.find(Product::id `in` ids.map { it })
                .descendingSort(Product::createdAt)
                .toList()
        } catch (e: Exception) {
            emptyList()
        }
    }

    override suspend fun getByName(name: String): Product? {
        return products.findOne(Product::name eq name)
    }

    override suspend fun updateOne(entity: Product): Boolean {
        return try {
            products.updateOne(
                filter = Product::id eq entity.id,
                update = combine(
                    setValue(Product::name, entity.name),
                    setValue(Product::description, entity.description),
                    setValue(Product::shortDescription, entity.shortDescription),
                    setValue(Product::imageUrls, entity.imageUrls),
                    setValue(Product::originalPrice, entity.originalPrice),
                    setValue(Product::discountPercentage, entity.discountPercentage),
                    setValue(Product::categories, entity.categories),
                )
            ).wasAcknowledged()
        } catch (e: Exception) {
            false
        }
    }

    override suspend fun deleteOneById(id: String): Boolean {
        return try {
            products.deleteOne(
                Product::id eq id
            ).wasAcknowledged()
        } catch (e: Exception) {
            false
        }
    }

    override suspend fun createOne(entity: Product): Boolean {
        var id = entity.id
        while (true) {
            val exists = getOneById(id) != null
            if (!exists) {
                break
            }
            id = UUID.randomUUID().toString()
        }
        return products.insertOne(entity).wasAcknowledged()
    }
}