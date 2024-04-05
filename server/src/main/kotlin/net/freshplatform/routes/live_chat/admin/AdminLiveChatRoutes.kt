package net.freshplatform.routes.live_chat.admin

import io.ktor.server.auth.*
import io.ktor.server.routing.*
import io.ktor.server.util.*
import io.ktor.server.websocket.*
import io.ktor.websocket.*
import net.freshplatform.data.live_chat.LiveChatRoom
import net.freshplatform.routes.live_chat.LiveChatRoomController
import net.freshplatform.utils.extensions.requireCurrentAdminUser

fun Route.adminLiveChatRoutes(controller: LiveChatRoomController) {
    route("/admin") {
        adminLiveChat(controller)
    }
}

fun Route.adminLiveChat(controller: LiveChatRoomController) {
    authenticate {
        /**
         * The [LiveChatRoom.clientUserId]
         * */
        webSocket("/{id}") {
            val id: String by call.parameters
            val currentUser = call.requireCurrentAdminUser()

            try {
                controller.onJoin(
                    clientUserId = id,
                    session = this
                )
                for (frame in incoming) {
                    frame as? Frame.Text ?: continue
                    val receivedText = frame.readText()
                    controller.sendMessage(
                        senderId = currentUser.id.toString(),
                        clientUserId = id,
                        text = receivedText
                    )
                }
            } catch (e: Exception) {
                e.printStackTrace()
            } finally {
                controller.disconnect(
                    clientUserId = id,
                    socketSession = this
                )
            }
        }
    }
}