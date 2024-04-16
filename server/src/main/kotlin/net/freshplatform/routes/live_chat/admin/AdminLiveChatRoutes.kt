package net.freshplatform.routes.live_chat.admin

import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import io.ktor.server.util.*
import io.ktor.server.websocket.*
import io.ktor.websocket.*
import net.freshplatform.data.live_chat.LiveChatDataSource
import net.freshplatform.data.live_chat.LiveChatRoom
import net.freshplatform.routes.live_chat.LiveChatRoomController
import net.freshplatform.utils.ErrorResponseException
import net.freshplatform.utils.extensions.requireCurrentAdminUser
import org.koin.ktor.ext.inject

fun Route.adminLiveChatRoutes(controller: LiveChatRoomController) {
    route("/admin") {
        adminLiveChat(controller)
        getMessages()
        getRooms()
        deleteRoom()
        roomsStatus(controller)
    }
}

fun Route.adminLiveChat(controller: LiveChatRoomController) {
    authenticate {
        /**
         * The id is [LiveChatRoom.roomClientUserId]
         * */
        webSocket("/{id}") {
            val id: String by call.parameters
            val currentUser = call.requireCurrentAdminUser()

            try {
                controller.onJoin(
                    roomClientUserId = id,
                    session = this
                )
                for (frame in incoming) {
                    frame as? Frame.Text ?: continue
                    val receivedText = frame.readText()
                    controller.sendMessage(
                        senderId = currentUser.id.toString(),
                        roomClientUserId = id,
                        text = receivedText
                    )
                }
            } catch (e: Exception) {
                e.printStackTrace()
            } finally {
                controller.disconnect(
                    roomClientUserId = id,
                    socketSession = this
                )
            }
        }
    }
}

fun Route.getMessages() {
    val liveChatDataSource by inject<LiveChatDataSource>()
    authenticate {
        /**
         * The id is [LiveChatRoom.roomClientUserId]
         * */
        get("/messages/{id}") {
            call.requireCurrentAdminUser()
            val id: String by call.parameters
            val page: Int by call.request.queryParameters
            val limit: Int by call.request.queryParameters

            val messages = liveChatDataSource.getAllMessagesByRoomClientUserId(id, page, limit).getOrElse {
                throw ErrorResponseException(
                    HttpStatusCode.InternalServerError,
                    "Unknown error while getting the messages.",
                    "COULD_NOT_LOAD_MESSAGES"
                )
            }.map { it.toResponse() }
            call.respond(messages)
        }
    }
}

fun Route.getRooms() {
    val liveChatDataSource by inject<LiveChatDataSource>()
    authenticate {
        get("/rooms") {
            call.requireCurrentAdminUser()
            val page: Int by call.request.queryParameters
            val limit: Int by call.request.queryParameters

            val rooms = liveChatDataSource.getAllRooms(page, limit).getOrElse {
                throw ErrorResponseException(
                    HttpStatusCode.InternalServerError,
                    "Unknown error while loading the rooms: ${it.message}",
                    "COULD_NOT_LOAD_ROOMS"
                )
            }.map { it.toResponse() }

            call.respond(rooms)
        }
    }
}

fun Route.deleteRoom() {
    val liveChatDataSource by inject<LiveChatDataSource>()
    authenticate {
        /**
         * The id is [LiveChatRoom.id]
         * */
        delete("/rooms/{id}") {
            call.requireCurrentAdminUser()
            val id: String by call.parameters

            val isDeleteSuccess = liveChatDataSource.deleteRoomById(id)
            if (!isDeleteSuccess) {
                throw ErrorResponseException(
                    HttpStatusCode.InternalServerError,
                    "Unknown error while deleting the room with id: $id",
                    "COULD_NOT_DELETE_ROOM"
                )
            }
            call.respondText { "The room has been successfully deleted." }
        }
    }
}

// This route will not be used in the client app
fun Route.roomsStatus(
    controller: LiveChatRoomController
) {
    authenticate {
        get("/rooms/status") {
            call.requireCurrentAdminUser()
            val message = buildString {
                append("Rooms = ${controller.roomsCount()}\n")
                controller.roomsStatusMessage()
            }
            call.respondText { message }
        }
    }
}