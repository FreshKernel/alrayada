package net.freshplatform.routes.user

import kotlinx.serialization.Serializable
import net.freshplatform.data.user.UserResponse

@Serializable
data class AuthSignInResponse(
    val token: String,
    val expiresIn: Long,
    val expiresAt: Long,
    val user: UserResponse
)