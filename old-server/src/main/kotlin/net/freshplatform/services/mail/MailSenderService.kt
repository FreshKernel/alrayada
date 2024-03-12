package net.freshplatform.services.mail

interface MailSenderService {
    suspend fun sendEmail(
        emailMessage: EmailMessage
    ): Boolean
}