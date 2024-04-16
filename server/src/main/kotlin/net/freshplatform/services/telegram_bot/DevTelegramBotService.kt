package net.freshplatform.services.telegram_bot

class DevTelegramBotService: TelegramBotService {
    override suspend fun sendMessage(text: String): Boolean {
        println(
            """
           Telegram message: $text
        """.trimIndent()
        )
        return true
    }
}