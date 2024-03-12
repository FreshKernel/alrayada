package net.freshplatform.routes.user

import net.freshplatform.data.user.UserData
import net.freshplatform.data.user.UserDeviceNotificationsToken
import net.freshplatform.utils.extensions.isPasswordStrong
import net.freshplatform.utils.extensions.isValidEmail
import kotlinx.serialization.Serializable

@Serializable
data class AuthSignUpRequest(
    val email: String,
    val password: String,
    val deviceToken: UserDeviceNotificationsToken,
    val userData: UserData
) {
    fun validate(): Pair<String, String>? {
        return when {
            !email.isValidEmail() -> Pair("Please enter valid email address", "INVALID_EMAIL")
            email.length > 100 -> Pair("Email is too long", "EMAIL_TOO_LONG")
            password.length >= 255 -> Pair("Password is too long", "PASSWORD_TOO_LONG")
            password.length < 8 -> Pair("Password is too short", "PASSWORD_TOO_SHORT")
            !password.isPasswordStrong() -> Pair("Please enter a strong password", "PASSWORD_WEAK") // TODO: Recheck this on client and server
            userData.validate() != null -> userData.validate()
            else -> null
        }
    }
}

@Serializable
data class AuthSignInRequest(
    val email: String,
    val password: String,
    val deviceToken: UserDeviceNotificationsToken?,
) {

    fun validate(): Pair<String, String>? {
        return when {
            !email.isValidEmail() -> Pair("Please enter valid email address", "INVALID_EMAIL")
            password.isBlank() -> Pair("Please enter your password", "PASSWORD_EMPTY")
            email.length > 100 -> Pair("Email is too long", "EMAIL_TOO_LONG")
            password.length >= 50 -> Pair("Password is too long", "PASSWORD_TOO_LONG")
            password.length < 8 -> Pair("Password is too short", "PASSWORD_TOO_SHORT")
            else -> null
        }
    }
}