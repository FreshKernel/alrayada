package net.freshplatform.services.secret_variables

class JavaSystemEnvironmentSecretVariables : SecretVariables {
    override fun getString(name: SecretVariablesName): String? =
        System.getenv(name.value) ?: null

    override fun getString(name: SecretVariablesName, defaultValue: String): String = System.getenv(name.value) ?: defaultValue
    override fun require(name: SecretVariablesName): String {
        return getString(name) ?: throw IllegalArgumentException("'${name.value}' environment variable is not defined")
    }
}