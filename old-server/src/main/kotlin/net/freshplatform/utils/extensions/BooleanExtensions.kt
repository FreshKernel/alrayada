package net.freshplatform.utils.extensions

import net.freshplatform.services.secret_variables.SecretVariablesName
import net.freshplatform.services.secret_variables.SecretVariablesService

fun isProductionMode(): Boolean = SecretVariablesService.require(SecretVariablesName.ProductionMode).toBoolean()

/**
 * Used to know if the running server in the cloud or not, to have path for 'files' folder for example
 * Note: just because application running in production server, doesn't mean
 * the production mode is true
 * */
fun isProductionServer(): Boolean = SecretVariablesService.require(SecretVariablesName.ProductionServer).toBoolean()
//fun isServerDevelopmentMode(): Boolean = SecretVariablesService.getString(SecretVariablesName.ServerDevelopmentMode, "true").toBoolean()