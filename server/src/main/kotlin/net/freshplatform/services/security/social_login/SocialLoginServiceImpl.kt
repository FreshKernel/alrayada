package net.freshplatform.services.security.social_login

import com.auth0.jwt.JWT
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier
import com.google.api.client.http.javanet.NetHttpTransport
import com.google.api.client.json.gson.GsonFactory
import net.freshplatform.Constants
import net.freshplatform.utils.getEnvironmentVariables
import java.util.*

class SocialLoginServiceImpl : SocialLoginService {
    private val googleIdTokenVerifier =
        GoogleIdTokenVerifier.Builder(NetHttpTransport(), GsonFactory())
            .setAudience(Collections.singletonList(getEnvironmentVariables().googleClientId))
            .build()

    override suspend fun authenticateWith(socialLogin: SocialLogin): Result<SocialLoginUserData?> {
        return try {
            return when (socialLogin) {
                is SocialLogin.Google -> {
                    val idToken: GoogleIdToken =
                        googleIdTokenVerifier.verify(socialLogin.idToken) ?: return Result.success(null)
                    val payload = idToken.payload

                    val pictureUrl: String = payload.getOrDefault("picture", "") as String
                    val name: String = payload.getOrDefault("name", "") as String
                    Result.success(
                        SocialLoginUserData(
                            email = payload.email,
                            isEmailVerified = payload.emailVerified,
                            pictureUrl = pictureUrl,
                            name = name,
                        )
                    )
                }

                is SocialLogin.Apple -> {
                    val kid = JWT.decode(socialLogin.identityToken).getHeaderClaim("kid").asString()
                    val appleKey = SignInWithApple.getAppleSingingKey(kid).getOrElse { return Result.failure(it) }
                    val validatedJwt = SignInWithApple.verifyJWT(socialLogin.identityToken, appleKey)
                        .getOrElse { return Result.failure(it) } ?: return Result.success(null)

                    val audience = validatedJwt.audience.first()

                    if (validatedJwt.subject != socialLogin.userIdentifier) {
                        return Result.success(null)
                    }

                    if (audience != Constants.AppId.IOS && audience != Constants.AppId.APPLE_AUTH_SERVICE_ID) {
                        return Result.success(null)
                    }

                    return Result.success(
                        SocialLoginUserData(
                            email = validatedJwt.getClaim("email").asString(),
                            isEmailVerified = validatedJwt.getClaim("email_verified").asBoolean(),
                            pictureUrl = "",
                            name = ""
                        )
                    )

                }
            }
        } catch (e: Exception) {
            e.printStackTrace()
            Result.failure(e)
        }
    }
}