package net.freshplatform.utils.constants

import net.freshplatform.services.secret_variables.SecretVariablesName
import net.freshplatform.services.secret_variables.SecretVariablesService
import net.freshplatform.utils.extensions.isProductionMode

object TelegramConstants {

    fun getChatId(): String {
        if (isProductionMode()) {
            return SecretVariablesService.require(SecretVariablesName.TelegramProductionChatId)
        }
        return SecretVariablesService.require(SecretVariablesName.TelegramTestingChatId)
    }
}