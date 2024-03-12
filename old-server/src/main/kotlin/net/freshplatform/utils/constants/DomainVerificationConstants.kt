package net.freshplatform.utils.constants

object DomainVerificationConstants {
    object Google {
        const val JSON_DATA = "[\n" +
                "  {\n" +
                "    \"relation\": [\"delegate_permission/common.handle_all_urls\"],\n" +
                "    \"target\": {\n" +
                "      \"namespace\": \"android_app\",\n" +
                "      \"package_name\": \"${Constants.MobileAppId.ANDROID}\",\n" +
                "      \"sha256_cert_fingerprints\":\n" +
                "        [\"2B:F6:72:78:F2:37:28:02:BB:06:86:08:03:FE:E9:FE:D3:96:E5:A7:CE:B6:FF:45:EF:EF:4F:A6:7E:AA:2A:8F\", \"EB:B2:67:BA:87:42:1F:13:68:69:90:5E:E0:4B:38:69:DF:38:B8:25:4F:9C:52:58:C0:F4:BA:D8:65:F6:A4:C1\"]\n" +
                "    }\n" +
                "  }\n" +
                "]"
    }

    object APPLE {
        const val APPLE_AUTH_SERVICE_ID = "net.freshplatform.alrayada.service"
        private const val APPLE_TEAM_ID = "49FG29ZLGP"
        const val JSON_DATA = "{\n" +
                "  \"applinks\": {\n" +
                "    \"details\": [\n" +
                "      {\n" +
                "        \"appIDs\": [\n" +
                "          \"$APPLE_TEAM_ID.${Constants.MobileAppId.IOS}\"\n" +
                "        ],\n" +
                "        \"components\": [\n" +
                "          {\n" +
                "            \"/\": \"/products/*\",\n" +
                "            \"comment\": \"Matches any URL with a path that starts with /products/.\"\n" +
                "          },\n" +
                "          {\n" +
                "            \"/\": \"/orders/paymentGateways/*\",\n" +
                "            \"comment\": \"Matches any URL with a path that starts with /orders/paymentGateways/.\"\n" +
                "          }\n" +
                "        ]\n" +
                "      }\n" +
                "    ]\n" +
                "  }\n" +
                "}"
    }
}