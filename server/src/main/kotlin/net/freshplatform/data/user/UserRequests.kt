package net.freshplatform.data.user

import kotlinx.serialization.Serializable
import net.freshplatform.utils.extensions.isValidEmailAddress
import net.freshplatform.utils.extensions.isValidPassword

@Serializable
data class AuthSignUpRequest(
    val email: String,
    val password: String,
    val deviceNotificationsToken: UserDeviceNotificationsToken,
    val userInfo: UserInfo
) {
    fun validate(): Pair<String, String>? {
        return when {
            !email.isValidEmailAddress() -> Pair("Please enter valid email address", "INVALID_EMAIL")
            email.length > 100 -> Pair("Email is too long", "EMAIL_TOO_LONG")
            password.length > 255 -> Pair("Password is too long", "PASSWORD_TOO_LONG")
            password.length < 8 -> Pair("Password is too short", "PASSWORD_TOO_SHORT")
            !password.isValidPassword() -> Pair("Please enter a strong password", "PASSWORD_WEAK")
            userInfo.validate() != null -> userInfo.validate()
            else -> null
        }
    }
}

@Serializable
data class AuthSignInRequest(
    val email: String,
    val password: String,
    val deviceNotificationsToken: UserDeviceNotificationsToken?,
) {

    fun validate(): Pair<String, String>? {
        return when {
            !email.isValidEmailAddress() -> Pair("Please enter valid email address", "INVALID_EMAIL")
            password.isBlank() -> Pair("Please enter your password", "PASSWORD_EMPTY")
            email.length > 100 -> Pair("Email is too long", "EMAIL_TOO_LONG")
            password.length >= 50 -> Pair("Password is too long", "PASSWORD_TOO_LONG")
            password.length < 8 -> Pair("Password is too short", "PASSWORD_TOO_SHORT")
            else -> null
        }
    }
}