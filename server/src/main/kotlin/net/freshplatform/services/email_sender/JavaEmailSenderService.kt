package net.freshplatform.services.email_sender

import com.sun.mail.util.MailConnectException
import jakarta.mail.*
import jakarta.mail.internet.MimeMessage
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import net.freshplatform.utils.getEnvironmentVariables
import java.util.*

class JavaEmailSenderService : EmailSenderService {
    private val properties = Properties().apply {
        this["mail.smtp.host"] = getEnvironmentVariables().emailSmtpHost
        this["mail.smtp.port"] = "587"
        this["mail.smtp.auth"] = "true"
        this["mail.smtp.starttls.enable"] = "true"
    }
    private val session = Session.getInstance(properties, object : Authenticator() {
        override fun getPasswordAuthentication(): PasswordAuthentication {
            return PasswordAuthentication(
                getEnvironmentVariables().emailUsername,
                getEnvironmentVariables().emailPassword
            )
        }
    })

    override suspend fun sendEmail(message: EmailMessage): Boolean {
        return withContext(Dispatchers.IO) {
            try {
                val mimeMessage = MimeMessage(session).apply {
                    setFrom(getEnvironmentVariables().fromEmail)
                    setRecipients(
                        Message.RecipientType.TO,
                        message.to.lowercase().trim()
                    )
                    subject = message.subject
                    sentDate = Date(System.currentTimeMillis())
                    setText(message.body)
                }
                Transport.send(mimeMessage)
                true
            } catch (e: AuthenticationFailedException) {
                e.printStackTrace()
                false
            } catch (e: MessagingException) {
                e.printStackTrace()
                false
            } catch (e: MailConnectException) {
                e.printStackTrace()
                false
            } catch (e: java.net.ConnectException) {
                e.printStackTrace()
                false
            } catch (e: Exception) {
                e.printStackTrace()
                false
            }
        }
    }
}