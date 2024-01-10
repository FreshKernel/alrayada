package net.freshplatform.routes.chat.admin

import net.freshplatform.data.chat.ChatDataSource
import net.freshplatform.data.user.User
import net.freshplatform.data.user.UserData
import net.freshplatform.data.user.UserDataSource
import net.freshplatform.routes.chat.ChatRoomController
import net.freshplatform.utils.extensions.request.*
import net.freshplatform.utils.extensions.toJson
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import io.ktor.server.websocket.*
import io.ktor.websocket.*

class ChatAdminRoutes(
    private val router: Route,
    private val chatDataSource: ChatDataSource,
    private val userDataSource: UserDataSource,
    private val chatRoomController: ChatRoomController
) {

    fun chat() = router.authenticate {
        webSocket("/chat/{id}") {
            val adminUser = call.requireAdminUser()
            val chatRoomId = call.requireParameterId()

            chatRoomController.onJoin(
                chatRoomId = chatRoomId,
                socketSession = this
            )
            try {
                send("You are connected!".toJson())
                chatRoomController.loadPreviousMessages(
                    chatRoomId = chatRoomId,
                    socketSession = this
                )
                for (frame in incoming) {
                    frame as? Frame.Text ?: continue
                    val receivedText = frame.readText()
                    chatRoomController.sendMessage(
                        chatRoomId = chatRoomId,
                        senderId = adminUser.stringId(),
                        text = receivedText
                    )
                }
            } catch (e: Exception) {
                println(e.localizedMessage)
                e.printStackTrace()
            } finally {
                chatRoomController.tryDisconnect(
                    chatRoomId = chatRoomId,
                    socketSession = this
                )
            }
        }
    }

    fun getRooms() = router.authenticate {
        get("/rooms") {
            call.requireAdminUser()
            val limit = call.requestLimitParameter()
            val page = call.requestPageParameter()
            val rooms = chatDataSource.getAllRooms(
                limit = limit,
                page = page
            ).map {
                val user: User? = userDataSource.getUserByUUID(it.chatRoomId)
                it.toResponse(
                    user?.data ?: UserData.unknown()
                )
            }
            call.respond(HttpStatusCode.OK, rooms)
        }
    }

    fun deleteRoom() = router.authenticate {
        delete("/rooms/{id}") {
            call.requireAdminUser()
            val roomId = call.requireParameterId()
            val deleteSuccess = chatDataSource.deleteRoom(roomId)
            if (!deleteSuccess) {
                call.respondJsonText(HttpStatusCode.InternalServerError, "Error while delete chat room")
                return@delete
            }
            call.respondJsonText(HttpStatusCode.OK, "Deleted!")
        }
    }

    fun roomsStatus() = router.authenticate {
        get("/status") {
            call.requireAdminUser()
            call.respond(
                HttpStatusCode.OK,
                buildString {
                    append("Rooms = ${chatRoomController.chatRooms.count()}\n")
                    chatRoomController.chatRooms.forEach {
                        append("Room key = ${it.key}, value = ${it.value.members.count()}")
                    }
                },
            )
        }
    }

}