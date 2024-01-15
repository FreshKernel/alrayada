package net.freshplatform.services.secret_variables

import io.github.cdimascio.dotenv.dotenv

class DotenvSecretVariables : SecretVariables {
    companion object {
        private val dotenv = dotenv {
            ignoreIfMissing = true
            systemProperties = false
        }
    }
    override fun getString(name: SecretVariablesName): String? =
        dotenv[name.value] ?: null

    override fun getString(name: SecretVariablesName, defaultValue: String): String =
        dotenv[name.value] ?: defaultValue

    override fun require(name: SecretVariablesName): String {
        return getString(name) ?: throw IllegalArgumentException("'${name.value}' environment variable is not defined")
    }
}