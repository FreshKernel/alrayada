package net.freshplatform.services.telegram

import net.freshplatform.services.http_client.HttpService
import net.freshplatform.services.telegram.TelegramBotService.Companion.API_URL
import io.ktor.client.*
import io.ktor.client.request.*
import io.ktor.http.*

class KtorTelegramBotService(
    private val client: HttpClient = HttpService.client
): TelegramBotService {
    override suspend fun sendMessage(telegramMessage: TelegramMessage, telegramBotToken: String): Boolean {
        return try {
            val response = client.post("$API_URL/bot$telegramBotToken/sendMessage") {
                contentType(ContentType.Application.Json); setBody(telegramMessage)
            }
            response.status == HttpStatusCode.OK
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }

    override suspend fun sendMessage(text: String): Boolean {
        return sendMessage(TelegramMessage(text = text))
    }
}