package net.freshplatform.services.security.social_login

interface SocialLoginService {
    /**
     * In case of server error, will return Result.failure()
     * in case of client error, will return Result.success(null)
     * In case of success will return Result.success(result)
     * */
    suspend fun authenticateWith(socialLogin: SocialLogin): Result<SocialLoginUserData?>
}