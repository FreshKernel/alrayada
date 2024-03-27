package net.freshplatform.utils

import io.github.cdimascio.dotenv.dotenv

data class EnvironmentVariables(
    val mongoConnectionString: String,
    val apiKey: String,
    val accessTokenSecret: String,
    val refreshTokenSecret: String,
    /**
     * Used to know if the running server in the cloud or not
     * */
    val isProductionServer: Boolean,
    /**
     * Used to have different behavior depending on if this a development mode or not
     * */
    val isProductionMode: Boolean,
    val serverPort: Int,
    val emailSmtpHost: String,
    val emailUsername: String,
    val emailPassword: String,
    val fromEmail: String,
    val telegramBotToken: String,
    val telegramProductionChatId: String,
    val telegramDevelopmentChatId: String,
    val googleAndroidClientId: String,
    val googleIosClientId: String,
    val firebaseProjectId: String,
    /**
     * As plain text (json)
     * */
    val firebaseProjectServiceAccountKey: String,
    val zainCashMerchantId: String,
    val zainCashMerchantSecret: String,
    val zainCashMerchantMsiSdn: String,
    val zainCashApiUrl: String,
)

val dotenv = dotenv {
    systemProperties = true
    ignoreIfMissing = true
}

private fun getEnvironmentVariable(name: String): String {
    return dotenv.get(name) ?: throw IllegalArgumentException("The environment variable: $name is not defined")
}

fun getEnvironmentVariables(): EnvironmentVariables {
    return EnvironmentVariables(
        mongoConnectionString = getEnvironmentVariable("MONGO_CONNECTION_STRING"),
        apiKey = getEnvironmentVariable("API_KEY"),
        accessTokenSecret = getEnvironmentVariable("ACCESS_TOKEN_SECRET"),
        refreshTokenSecret = getEnvironmentVariable("REFRESH_TOKEN_SECRET"),
        isProductionServer = getEnvironmentVariable("PRODUCTION_SERVER").toBoolean(),
        isProductionMode = getEnvironmentVariable("PRODUCTION_MODE").toBoolean(),
        serverPort = getEnvironmentVariable("PORT").toInt(), // Must be "PORT"
        emailSmtpHost = getEnvironmentVariable("EMAIL_SMTP_HOST"),
        emailUsername = getEnvironmentVariable("EMAIL_USERNAME"),
        emailPassword = getEnvironmentVariable("EMAIL_PASSWORD"),
        fromEmail = getEnvironmentVariable("FROM_EMAIL"),
        telegramBotToken = getEnvironmentVariable("TELEGRAM_BOT_TOKEN"),
        telegramProductionChatId = getEnvironmentVariable("TELEGRAM_PRODUCTION_CHAT_ID"),
        telegramDevelopmentChatId = getEnvironmentVariable("TELEGRAM_DEVELOPMENT_CHAT_ID"),
        googleAndroidClientId = getEnvironmentVariable("GOOGLE_ANDROID_CLIENT_ID"),
        googleIosClientId = getEnvironmentVariable("GOOGLE_IOS_CLIENT_ID"),
        firebaseProjectId = getEnvironmentVariable("FIREBASE_PROJECT_ID"),
        firebaseProjectServiceAccountKey = getEnvironmentVariable("FIREBASE_PROJECT_SERVICE_ACCOUNT_KEY"),
        zainCashMerchantId = getEnvironmentVariable("ZAIN_CASH_MERCHANT_ID"),
        zainCashMerchantSecret = getEnvironmentVariable("ZAIN_CASH_MERCHANT_SECRET"),
        zainCashMerchantMsiSdn = getEnvironmentVariable("ZAIN_CASH_MERCHANT_SDN"),
        zainCashApiUrl = getEnvironmentVariable("ZAIN_CASH_API_URL"),
    )
}