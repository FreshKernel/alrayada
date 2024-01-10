package net.freshplatform.routes.chat

import net.freshplatform.data.chat.ChatDataSource
import net.freshplatform.utils.extensions.request.getCurrentUserNullable
import net.freshplatform.utils.extensions.request.requestLimitParameter
import net.freshplatform.utils.extensions.request.requestPageParameter
import net.freshplatform.utils.extensions.request.requireAuthenticatedUser
import net.freshplatform.utils.extensions.toJson
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import io.ktor.server.websocket.*
import io.ktor.websocket.*

class ChatRoutes(
    private val router: Route,
    private val chatDataSource: ChatDataSource,
    private val chatRoomController: ChatRoomController
) {
    fun userChat() = router.authenticate {
        webSocket("/") {
            val user = call.getCurrentUserNullable() ?: kotlin.run {
                close(CloseReason(CloseReason.Codes.VIOLATED_POLICY, "Authentication required"))
                return@webSocket
            }
            val userId = user.stringId()
            chatRoomController.onJoin(
                chatRoomId = userId,
                socketSession = this
            )
            try {
                send("You are connected!".toJson())
                chatRoomController.loadPreviousMessages(
                    chatRoomId = userId,
                    socketSession = this
                )
                for (frame in incoming) {
                    frame as? Frame.Text ?: continue
                    val receivedText = frame.readText()
                    chatRoomController.sendMessage(
                        chatRoomId = userId,
                        senderId = userId,
                        text = receivedText
                    )
                }
            } catch (e: Exception) {
                println(e.localizedMessage)
                e.printStackTrace()
            } finally {
                chatRoomController.tryDisconnect(
                    chatRoomId = userId,
                    socketSession = this
                )
            }
        }
    }

    fun loadMessages() = router.authenticate {
        get("/load") {
            val userId = call.requireAuthenticatedUser()
            val limit = call.requestLimitParameter()
            val page = call.requestPageParameter()
            val chatMessages = chatDataSource.getAllByRoomId(userId.stringId(), limit, page)
            val response = chatMessages.map { it.toResponse() }
            call.respond(HttpStatusCode.OK, response)
        }
    }
}