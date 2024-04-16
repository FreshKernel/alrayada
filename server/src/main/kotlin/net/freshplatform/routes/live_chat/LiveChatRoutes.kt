package net.freshplatform.routes.live_chat

import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import io.ktor.server.util.*
import io.ktor.server.websocket.*
import io.ktor.websocket.*
import net.freshplatform.data.live_chat.LiveChatDataSource
import net.freshplatform.routes.live_chat.admin.adminLiveChatRoutes
import net.freshplatform.utils.ErrorResponseException
import net.freshplatform.utils.extensions.requireCurrentUser
import org.koin.ktor.ext.inject

fun Route.liveChatRoutes() {
    val liveChatDataSource by inject<LiveChatDataSource>()
    val controller = LiveChatRoomController(
        liveChatDataSource = liveChatDataSource
    )
    route("/liveChat") {
        userLiveChat(controller)
        getMessages()
        adminLiveChatRoutes(controller)
    }
}

fun Route.userLiveChat(controller: LiveChatRoomController) {
    authenticate {
        webSocket("/") {
            val userId = requireCurrentUser().id.toString()
            try {
                controller.onJoin(
                    roomClientUserId = userId,
                    session = this
                )
                for (frame in incoming) {
                    frame as? Frame.Text ?: continue
                    val receivedText = frame.readText()
                    controller.sendMessage(
                        senderId = userId,
                        roomClientUserId = userId,
                        text = receivedText
                    )
                }
            } catch (e: Exception) {
                e.printStackTrace()
            } finally {
                controller.disconnect(
                    roomClientUserId = userId,
                    socketSession = this
                )
            }
        }
    }
}

fun Route.getMessages() {
    val liveChatDataSource by inject<LiveChatDataSource>()
    authenticate {
        get("/messages") {
            val user = call.requireCurrentUser()
            val page: Int by call.request.queryParameters
            val limit: Int by call.request.queryParameters

            val messages = liveChatDataSource.getAllMessagesByRoomClientUserId(user.id.toString(), page, limit).getOrElse {
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