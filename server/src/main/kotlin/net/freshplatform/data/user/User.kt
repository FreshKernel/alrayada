package net.freshplatform.data.user

import kotlinx.datetime.Instant
import kotlinx.serialization.Contextual
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import net.freshplatform.services.security.token_verification.TokenVerification
import net.freshplatform.utils.InstantAsBsonDateTime
import net.freshplatform.utils.extensions.isValidPhoneNumber
import org.bson.types.ObjectId


@Serializable
data class User(
    @SerialName("_id")
    @Contextual
    val id: ObjectId? = ObjectId(),
    val email: String,
    val password: String,
    val isEmailVerified: Boolean,
    val isAccountActivated: Boolean,
    val role: UserRole,
    val info: UserInfo,
    val pictureUrl: String?,
    val emailVerification: TokenVerification?,
    val resetPasswordVerification: TokenVerification?,
    val deviceNotificationsToken: UserDeviceNotificationsToken,
    @Serializable(with = InstantAsBsonDateTime::class)
    val createdAt: Instant,
    @Serializable(with = InstantAsBsonDateTime::class)
    val updatedAt: Instant,
) {
    fun toResponse() = UserResponse(
        userId = id.toString(),
        email = email,
        isEmailVerified = isEmailVerified,
        isAccountActivated = isAccountActivated,
        role = role,
        info = info,
        pictureUrl = pictureUrl,
        deviceNotificationsToken = deviceNotificationsToken,
        createdAt = createdAt,
        updatedAt = updatedAt
    )
    fun hasAdminPrivileges(): Boolean {
        // It could be IllegalArgumentException
        // but for security reasons here will also catch any kind of exception
        return try {
            role == UserRole.Admin
        } catch (e: IllegalArgumentException) {
            false
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }
}

@Serializable
data class UserDeviceNotificationsToken(
    val firebase: String = "",
    val oneSignal: String = ""
)

@Serializable
data class UserInfo(
    val labOwnerPhoneNumber: String,
    val labPhoneNumber: String,
    val labName: String,
    val labOwnerName: String,
    val city: IraqGovernorate,
) {
    companion object {
        fun unknown() = UserInfo(
            city = IraqGovernorate.Baghdad,
            labOwnerName = "Unknown (User deleted)",
            labName = "Unknown",
            labOwnerPhoneNumber = "",
            labPhoneNumber = ""
        )
    }

    fun validate(): Pair<String, String>? {
        return when {
            !labPhoneNumber.isValidPhoneNumber() -> Pair(
                "Please enter a valid lab phone number",
                "INVALID_PHONE_NUMBER",
            )

            !labPhoneNumber.isValidPhoneNumber() -> Pair(
                "Please enter a valid lab owner phone number",
                "INVALID_PHONE_NUMBER",
            )

            labName.isBlank() || labOwnerName.isBlank() -> Pair("Please don't enter any blank fields", "BLANK_FIELDS")
            else -> null
        }
    }
}

@Serializable
enum class IraqGovernorate {
    Baghdad,
    Basra,
    Maysan,
    DhiQar,
    Diyala,
    Karbala,
    Kirkuk,
    Najaf,
    Nineveh,
    Wasit,
    Anbar,
    SalahAlDin,
    Babil,
    Babylon,
    AlMuthanna,

    @SerialName("Al-Qadisiyyah")
    AlQadisiyyah,
    ThiQar,
}

@Serializable
enum class UserRole {
    Admin, User
}


@Serializable
data class UserResponse(
    val userId: String,
    val email: String,
    val isEmailVerified: Boolean,
    val isAccountActivated: Boolean,
    val role: UserRole,
    val info: UserInfo,
    val pictureUrl: String?,
    val deviceNotificationsToken: UserDeviceNotificationsToken,
    val createdAt: Instant,
    val updatedAt: Instant,
)

@Serializable
data class AuthenticatedUserResponse(
    val accessToken: String,
    val refreshToken: String,
    val user: UserResponse
)