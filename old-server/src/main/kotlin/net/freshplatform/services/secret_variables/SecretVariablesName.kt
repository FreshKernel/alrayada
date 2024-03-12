package net.freshplatform.services.secret_variables

enum class SecretVariablesName(val value: String, val isRequired: Boolean) {
    DatabaseUrl("DATABASE_URL", true),
    ApiKey("API_KEY", true),
    JwtSecret("JWT_SECRET", true),

    /**
     * For ktor server to auto reload and get more logs
     * */
    ServerDevelopmentMode("SERVER_DEVELOPMENT_MODE", true),

    /**
     * Used to have different behavior depending on if this a development mode or not
     * */
    ProductionMode("PRODUCTION_MODE", true),
    /**
     * Used to know if the running server in the cloud or not, to have path for 'files' folder for example
     * */
    ProductionServer("PRODUCTION_SERVER", true),
    ServerPort("PORT", false),
    EmailSmtpHost("EMAIL_SMTP_HOST", true),
    EmailUsername("EMAIL_USERNAME", true),
    EmailPassword("EMAIL_PASSWORD", true),
    FromEmail("FROM_EMAIL", false),
    TelegramBotToken("TELEGRAM_BOT_TOKEN", true),
    TelegramProductionChatId("TELEGRAM_PRODUCTION_CHAT_ID", true),
    TelegramTestingChatId("TELEGRAM_TESTING_CHAT_ID", true),
    GoogleClientId("GOOGLE_CLIENT_ID", true),
    ZainCashMerchantId("ZAIN_CASH_MERCHANT_ID", false),
    ZainCashMerchantSecret("ZAIN_CASH_MERCHANT_SECRET", false),
    ZainCashMerchantMsiSdn("ZAIN_CASH_MERCHANT_MSISDN", false),
    ZainCashApiUrl("ZAIN_CASH_API_URL", false),
    DollarInDinar("DOLLAR_IN_DINAR", false),
    OneSignalAppId("ONE_SIGNAL_APP_ID", true),
    OneSignalRestApiKey("ONE_SIGNAL_REST_API_KEY", true)
}