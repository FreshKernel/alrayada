package net.freshplatform.services.telegram_bot

interface TelegramBotService {
    suspend fun sendMessage(text: String): Boolean
}