package net.freshplatform

object Constants {
    const val DATABASE_NAME = "alrayada"
    const val APP_NAME = "Alrayada"

    const val PRODUCTION_WEBSITE = "https://alrayada.net"
    const val MAXIMUM_IMAGE_UPLOAD_SIZE = 25 * 1024 * 1024L

    object JwtConfig {
        const val ISSUER = PRODUCTION_WEBSITE
        const val AUDIENCE = APP_NAME
        const val REALM = APP_NAME
    }

    object ClientAppId {
        private const val APP_ID = "net.freshplatform.alrayada"
        const val ANDROID = APP_ID
        const val IOS = APP_ID


        const val APPLE_AUTH_SERVICE_ID = ""
    }

    object Patterns {
        /**
         * Phone number pattern for the audience
         * */
        const val PHONE_NUMBER = "^07\\d{9}\$"
        const val EMAIL_ADDRESS = ("[a-zA-Z0-9\\+\\.\\_\\%\\-\\+]{1,256}" +
                "\\@" +
                "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
                "(" +
                "\\." +
                "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
                ")+")

        // Strong password
        const val PASSWORD = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$"
    }
}