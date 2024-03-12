package net.freshplatform.services.security.social_authentication

import net.freshplatform.data.user.UserData
import net.freshplatform.data.user.UserDeviceNotificationsToken
import kotlinx.serialization.Serializable

@Serializable
sealed class SocialAuthentication {
    abstract val signUpUserData: UserData?
    abstract val deviceToken: UserDeviceNotificationsToken

    @Serializable
    data class Google(
        val idToken: String,
        override val signUpUserData: UserData? = null,
        override val deviceToken: UserDeviceNotificationsToken,
    ) : SocialAuthentication()

    @Serializable
    data class Apple(
        val identityToken: String,
        val userId: String,
        override val signUpUserData: UserData? = null,
        override val deviceToken: UserDeviceNotificationsToken,
    ) : SocialAuthentication()

//    @Serializable
//    data class Facebook(
//        val accessToken : String,
//        override val signUpUserData: UserData? = null,
//        override val deviceToken: UserDeviceNotificationsToken,
//    ): SocialAuthentication()
}

data class SocialAuthUserData(
    val email: String,
    val emailVerified: Boolean = false,
    val pictureUrl: String = "",
    val name: String = "",
)

interface SocialAuthenticationService {
    suspend fun authenticateWith(socialAuthData: SocialAuthentication): SocialAuthUserData?
}