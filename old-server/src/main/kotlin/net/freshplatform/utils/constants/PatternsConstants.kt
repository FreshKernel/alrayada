package net.freshplatform.utils.constants

object PatternsConstants {
    const val PASSWORD = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$"
    const val PHONE_NUMBER: String = "^07\\d{9}\$"
}