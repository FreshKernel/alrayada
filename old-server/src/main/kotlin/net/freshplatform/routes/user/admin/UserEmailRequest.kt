package net.freshplatform.routes.user.admin

import kotlinx.serialization.Serializable
import net.freshplatform.utils.extensions.isValidEmail

@Serializable
data class UserEmailRequest(
    val email: String
) {
    fun validate(): String? {
        return when {
            !email.isValidEmail() -> "Please enter valid email address"
            else -> null
        }
    }
}