package net.freshplatform.services.security.social_login

import com.auth0.jwt.JWT
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier
import com.google.api.client.http.javanet.NetHttpTransport
import com.google.api.client.json.gson.GsonFactory
import net.freshplatform.Constants
import net.freshplatform.utils.getEnvironmentVariables

class SocialLoginServiceImpl : SocialLoginService {
    private val googleIdTokenVerifier =
        GoogleIdTokenVerifier.Builder(NetHttpTransport(), GsonFactory())
            .setAudience(
                listOf(
                    getEnvironmentVariables().googleAndroidClientId,
                    getEnvironmentVariables().googleIosClientId
                )
            )
            .build()

    override suspend fun authenticateWith(socialLogin: SocialLogin): Result<SocialLoginUserData?> {
        return try {
            return when (socialLogin) {
                is SocialLogin.Google -> {
                    val idToken: GoogleIdToken =
                        googleIdTokenVerifier.verify(socialLogin.idToken) ?: return Result.success(null)
                    val payload = idToken.payload

                    val pictureUrl = payload.getOrDefault("picture", null) as String?
                    val name = payload.getOrDefault("name", "") as String
                    Result.success(
                        SocialLoginUserData(
                            email = payload.email ?: return Result.failure(NullPointerException("The email is null")),
                            isEmailVerified = payload.emailVerified
                                ?: return Result.failure(NullPointerException("The is email verified is null")),
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

                    if (audience != Constants.ClientAppId.IOS && audience != Constants.ClientAppId.APPLE_AUTH_SERVICE_ID) {
                        return Result.success(null)
                    }

                    return Result.success(
                        SocialLoginUserData(
                            email = validatedJwt.getClaim("email").asString() ?: return Result.failure(
                                NullPointerException("The email is null")
                            ),
                            isEmailVerified = validatedJwt.getClaim("email_verified").asBoolean()
                                ?: return Result.failure(NullPointerException("The is email verified is null")),
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