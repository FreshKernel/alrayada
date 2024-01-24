package net.freshplatform.services.email_sender

class DevEmailSenderService : EmailSenderService {
    override suspend fun sendMessage(message: EmailMessage): Boolean {
        println(
            """
           Email subject: ${message.subject},
           Email to: ${message.to},
           Email body:
          ${message.body}
        """.trimIndent()
        )
        return true
    }
}