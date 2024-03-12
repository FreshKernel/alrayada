package net.freshplatform.services.mail

import net.freshplatform.services.secret_variables.SecretVariablesName
import net.freshplatform.services.secret_variables.SecretVariablesService
import com.sun.mail.util.MailConnectException
import jakarta.mail.*
import jakarta.mail.internet.InternetAddress
import jakarta.mail.internet.MimeMessage
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import java.util.*

//import javax.mail.*
//import javax.mail.internet.InternetAddress
//import javax.mail.internet.MimeMessage

class JavaMailSenderService: MailSenderService {
    companion object {
        const val GOOGLE_SMTP_HOST = "smtp.gmail.com"
        const val ZOHO_SMTP_HOST = "smtp.zoho.in"
    }
    private val props = Properties().apply {
        this["mail.smtp.host"] = ZOHO_SMTP_HOST
        this["mail.smtp.port"] = "587"
        this["mail.smtp.auth"] = "true"
        this["mail.smtp.starttls.enable"] = "true"
    }
    private val emailUsername = SecretVariablesService.require(SecretVariablesName.EmailUsername)
    private val emailPassword = SecretVariablesService.require(SecretVariablesName.EmailPassword)
    private val fromEmail = SecretVariablesService.getString(SecretVariablesName.FromEmail, emailUsername)

    private val session: Session = Session.getInstance(props, object : Authenticator() {
        override fun getPasswordAuthentication(): PasswordAuthentication {
            val username = emailUsername
            val password = emailPassword
            return PasswordAuthentication(username, password)
        }
    })
    override suspend fun sendEmail(emailMessage: EmailMessage): Boolean = withContext(Dispatchers.IO) {
        return@withContext try {
            val message = MimeMessage(session)
            val from = fromEmail
            message.setFrom(InternetAddress(from))
            message.setRecipients(
                Message.RecipientType.TO,
                emailMessage.to.lowercase().trim()
            )
            message.subject = emailMessage.subject
            message.sentDate = Date(System.currentTimeMillis())
            message.setText(emailMessage.body)
            Transport.send(message)
            true
        } catch (e: AuthenticationFailedException) {
            println("Authentication with email didn't success!")
            false
        } catch (mex: MessagingException) {
            println("send failed, exception: $mex")
            false
        } catch (e: MailConnectException) {
            println("email send failed, exception: $e")
            false
        }
        catch (e: java.net.ConnectException) {
            println("Connection failed: $e")
            false
        }
        catch (e: Exception) {
            e.printStackTrace()
            println("Unhandled exception while send email ${e.javaClass.name} from ${e.javaClass.packageName}")
            false
        }
    }
}