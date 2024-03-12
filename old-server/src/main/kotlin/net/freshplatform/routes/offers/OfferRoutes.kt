package net.freshplatform.routes.offers

import io.ktor.http.*
import io.ktor.http.content.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.request.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import net.freshplatform.data.offer.Offer
import net.freshplatform.data.offer.OfferDataSource
import net.freshplatform.utils.extensions.createFile
import net.freshplatform.utils.extensions.deleteAwait
import net.freshplatform.utils.extensions.request.*
import java.io.File

class OfferRoutes(
    private val router: Route,
    private val offerDataSource: OfferDataSource
) {
    companion object {
        const val NAME = "offers"
    }

    private fun getOffersImagesFolder() = File(getImageFolder(), NAME)

    fun getAll() = router.get("/") {
        call.protectRouteToAppOnly()
        call.respond(HttpStatusCode.OK, offerDataSource.getAll().map { it.toResponse(call) })
    }
    fun createOne() = router.authenticate {
        post("/") {
            call.requireAdminUser()
            val multipart = call.receiveMultipart()
//            var json = ""
            var file = File("")
            multipart.forEachPart { partData ->
                when (partData) {
                    is PartData.FormItem -> {
//                        if (partData.name != "json") return@forEachPart
//                        json = partData.value
                    }

                    is PartData.FileItem -> {
                        file = partData.createFile(File(getOffersImagesFolder(), partData.originalFileName!!))
                    }

                    else -> {
                        call.respondJsonText(HttpStatusCode.BadRequest, "Bad request")
                    }
                }
            }

            if (!file.exists()) {
                call.respondJsonText(HttpStatusCode.BadRequest, "Offer image doesn't exists")
                return@post
            }

            val offer = Offer(imageUrl = "/${NAME}/${file.name}")
            val success = offerDataSource.insertOne(offer)
            if (!success) {
                call.respondJsonText(HttpStatusCode.InternalServerError, "Error while insert the offer to the database")
                return@post
            }

            call.respond(HttpStatusCode.OK, offer.toResponse(call))
        }
    }

    fun deleteOne() = router.authenticate {
        delete("/{id}") {
            val id = call.requireParameterId()
            val currentOffer = offerDataSource.getOneById(id) ?: kotlin.run {
                call.respondJsonText(HttpStatusCode.NotFound, "There is no offer with that id")
                return@delete
            }
            File(getImageFolder(), currentOffer.imageUrl).deleteAwait()
            val success = offerDataSource.deleteOneById(currentOffer.stringId())
            if (!success) {
                call.respondJsonText(HttpStatusCode.InternalServerError, "Error while delete the offer")
                return@delete
            }
            call.respond(HttpStatusCode.NoContent, "Offer has been successfully deleted!")
        }
    }
}