package net.freshplatform.utils.constants

object Constants {
    const val APP_NAME = "Alrayada"
    const val APP_DATABASE_NAME = "alrayada_app"
    const val FIREBASE_PROJECT_ID = "alreada-19031"

    object MobileAppId {
        private const val MOBILE_APP_ID = "net.freshplatform.alrayada"
        const val ANDROID = MOBILE_APP_ID
        const val IOS = MOBILE_APP_ID
    }

    private const val DOMAIN_NAME = "alrayada.net"
    const val PRODUCTION_WEBSITE = "https://$DOMAIN_NAME"
    const val PRODUCTION_API_URL = "${PRODUCTION_WEBSITE}/api/"
    const val DEFAULT_SERVER_PORT = 8080

    object Folders {
        const val LOCKED_FILE_NAME = ".serverLock"
        const val SERVER_PUBLIC_FILES = "files"
    }

    const val DESCRIPTION = "Alrayada app website"
    const val SUPPORT_EMAIL = "support@$DOMAIN_NAME"
    const val DEVELOPER_WEBSITE = "https://freshplatform.net"

    const val DEFAULT_DOLLAR_IN_DINAR = 1500

    object JwtConfig {
        const val DOMAIN = PRODUCTION_WEBSITE
        const val AUDIENCE = APP_NAME
        const val REALM = APP_NAME
    }
}