package net.freshplatform.data.user


import kotlinx.datetime.Instant
import kotlinx.serialization.Contextual
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import net.freshplatform.services.security.token_verification.TokenVerification
import net.freshplatform.utils.extensions.isValidPhoneNumber
import org.bson.types.ObjectId


data class User(
    @SerialName("_id")
    @Contextual
    val id: ObjectId? = ObjectId(),
    val email: String,
    val password: String,
    val isEmailVerified: Boolean,
    val isAccountActivated: Boolean,
    val role: UserRole,
    val data: UserData,
    val pictureUrl: String?,
    val emailVerification: TokenVerification?,
    val forgotPasswordVerification: TokenVerification?,
    val deviceNotificationsToken: UserDeviceNotificationsToken,
    val createdAt: Instant,
    val updatedAt: Instant,
) {
    fun toResponse() = UserResponse(
        email = email,
        isEmailVerified = isEmailVerified,
        isAccountActivated = isAccountActivated,
        role = role,
        data = data,
        pictureUrl = pictureUrl,
        deviceNotificationsToken = deviceNotificationsToken,
        createdAt = createdAt,
        updatedAt = updatedAt
    )
}

@Serializable
data class UserDeviceNotificationsToken(
    val firebase: String = "",
    val oneSignal: String = ""
)

@Serializable
data class UserData(
    val labOwnerPhoneNumber: String,
    val labPhoneNumber: String,
    val labName: String,
    val labOwnerName: String,
    val city: IraqGovernorate,
) {
    companion object {
        fun unknown() = UserData(
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
    val email: String,
    val isEmailVerified: Boolean,
    val isAccountActivated: Boolean,
    val role: UserRole,
    val data: UserData,
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