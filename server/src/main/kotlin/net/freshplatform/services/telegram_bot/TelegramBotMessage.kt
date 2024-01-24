package net.freshplatform.services.telegram_bot

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class TelegramBotMessage(
    val text: String,
    @SerialName("chat_id")
    val chatId: String,
    @SerialName("parse_mode")
    val parseMode: String = "HTML"
)
