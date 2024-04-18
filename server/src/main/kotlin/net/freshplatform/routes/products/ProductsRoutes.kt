package net.freshplatform.routes.products

import io.ktor.server.routing.*
import net.freshplatform.routes.products.categories.productCategoriesRoutes

fun Route.productsRoutes() {
    route("/products") {
        productCategoriesRoutes()
    }
}