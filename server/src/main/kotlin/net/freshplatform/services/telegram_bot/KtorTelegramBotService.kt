package net.freshplatform.services.telegram_bot

import io.ktor.client.*
import io.ktor.client.request.*
import io.ktor.http.*
import net.freshplatform.utils.getEnvironmentVariables

class KtorTelegramBotService(
    private val client: HttpClient
) : TelegramBotService {
    companion object {
        const val API_URL = "https://api.telegram.org"
    }

    override suspend fun sendMessage(text: String): Boolean {
        return try {
            val response = client.post("${API_URL}/bot${getEnvironmentVariables().telegramBotToken}/sendMessage") {
                contentType(ContentType.Application.Json)
                setBody(
                    TelegramBotMessage(
                        text,
                        if (getEnvironmentVariables().isProductionMode) getEnvironmentVariables().telegramProductionChatId else getEnvironmentVariables().telegramDevelopmentChatId
                    )
                )
            }
            response.status == HttpStatusCode.OK
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }
}