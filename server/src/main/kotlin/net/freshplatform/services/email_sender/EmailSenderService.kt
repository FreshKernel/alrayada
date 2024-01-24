package net.freshplatform.services.email_sender

interface EmailSenderService {
    suspend fun sendMessage(message: EmailMessage): Boolean
}