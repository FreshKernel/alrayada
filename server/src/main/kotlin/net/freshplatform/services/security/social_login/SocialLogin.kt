package net.freshplatform.services.security.social_login

import kotlinx.serialization.Serializable
import net.freshplatform.data.user.UserDeviceNotificationsToken
import net.freshplatform.data.user.UserInfo

@Serializable
sealed class SocialLogin {
    @Serializable
    data class Google(
        val idToken: String,
        val accessToken: String
    ) : SocialLogin()

    @Serializable
    data class Apple(
        val identityToken: String,
        val authorizationCode: String,
        val userIdentifier: String
    ): SocialLogin()
}

@Serializable
data class SocialLoginRequest<T>(
    val socialLogin: T,
    // Used for sign up only
    val userInfo: UserInfo?,
    val deviceNotificationsToken: UserDeviceNotificationsToken
)

// The data returned from the authentication with social providers
@Serializable
data class SocialLoginUserData(
    val email: String,
    val isEmailVerified: Boolean,
    val pictureUrl: String,
    val name: String,
)