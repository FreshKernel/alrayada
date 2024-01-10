package net.freshplatform.data.user

import net.freshplatform.services.security.verification_token.TokenVerification
import net.freshplatform.utils.constants.PatternsConstants
import net.freshplatform.utils.extensions.matchPattern
import net.freshplatform.utils.extensions.request.getImageClientUrl
import net.freshplatform.utils.helpers.LocalDateTimeSerializer
import com.fasterxml.jackson.databind.exc.InvalidFormatException
import io.ktor.server.application.*
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import java.time.LocalDateTime
import java.util.*

data class User(
    val uuid: String,
    val accountActivated: Boolean = false,
    val emailVerified: Boolean = false,
    val tokenVerifications: Set<TokenVerification>,
    val role: UserRole = UserRole.User,
    val email: String,
    val password: String,
    val salt: String,
    val data: UserData,
    val deviceNotificationsToken: UserDeviceNotificationsToken,
    val pictureUrl: String = "",
    val createdAt: LocalDateTime
) {
    fun stringId() = uuid
    fun hasAdminPrivileges(): Boolean {
        // it could be InvalidFormatException, IllegalArgumentException
        // but for security reasons here will also catch any kind of exception
        return try {
            role == UserRole.Admin
        } catch (e: IllegalArgumentException) {
            false
        } catch (e: InvalidFormatException) {
            false
        } catch (e: Exception) {
            e.printStackTrace()
            println("Unhandled exception: ${e.message}")
            false
        }
    }

    fun toResponse(call: ApplicationCall) = UserResponse(
        userId = stringId(),
        accountActivated = accountActivated,
        emailVerified = emailVerified,
        role = role,
        email = email,
        data = data,
        createdAt = createdAt,
        pictureUrl = call.getImageClientUrl(pictureUrl),
    )
    companion object {
        suspend fun generateUniqueUUID(userDataSource: UserDataSource): String {
            fun generateRandomUUID(): String = UUID.randomUUID().toString()
            var uuid = generateRandomUUID()
            while (true) {
                val uuidUsed = userDataSource.getUserByUUID(uuid) != null
                if (!uuidUsed) {
                    break
                }
                uuid = generateRandomUUID()
            }
            return uuid
        }
        object TokenVerificationData {
            object EmailVerification {
                const val NAME = "emailVerification"
                fun find(user: User): TokenVerification? = user.tokenVerifications.find { tokenVerification -> tokenVerification.name == NAME }
            }
            object ForgotPassword {
                const val NAME = "forgotPassword"
                fun find(user: User): TokenVerification? = user.tokenVerifications.find { tokenVerification -> tokenVerification.name == NAME }
            }
        }
    }
}

@Serializable
data class UserResponse(
    val userId: String,
    val accountActivated: Boolean = false,
    val emailVerified: Boolean = false,
    val role: UserRole = UserRole.User,
    val email: String,
    val data: UserData,
    val pictureUrl: String = "",
    @Serializable(with = LocalDateTimeSerializer::class)
    val createdAt: LocalDateTime
)

@Serializable
enum class UserRole {
    Admin, User
}

@Serializable
data class UserDeviceNotificationsToken(
    val firebase: String = "",
    val oneSignal: String = ""
) {
    fun validate(): Boolean = when {
        else -> true
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
            !labPhoneNumber.matchPattern(PatternsConstants.PHONE_NUMBER) -> Pair("Please enter a valid lab phone number", "INVALID_PHONE_NUMBER")
            !labOwnerPhoneNumber.matchPattern(PatternsConstants.PHONE_NUMBER) -> Pair("Please enter a valid lab owner phone number", "INVALID_PHONE_NUMBER")
            labName.isBlank() || labOwnerName.isBlank() -> Pair("Please don't enter any blank fields", "BLANK_FIELDS")
            else -> null
        }
    }
}
