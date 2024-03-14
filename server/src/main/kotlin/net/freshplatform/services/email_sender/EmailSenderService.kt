package net.freshplatform.services.email_sender

interface EmailSenderService {
    suspend fun sendEmail(message: EmailMessage): Boolean
}