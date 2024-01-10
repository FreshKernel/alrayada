package net.freshplatform.services.secret_variables

object SecretVariablesService : SecretVariables {
    private val service: SecretVariables = DotenvSecretVariables()

    fun javaSystemEnvironment(): SecretVariables = JavaSystemEnvironmentSecretVariables()
    fun dotenv(): SecretVariables = DotenvSecretVariables()
    override fun getString(name: SecretVariablesName): String? {
        return service.getString(name)
    }

    override fun getString(name: SecretVariablesName, defaultValue: String): String {
        return service.getString(name, defaultValue)
    }
    override fun require(name: SecretVariablesName): String {
        val value = service.require(name)
        if (value.isBlank()) {
            throw IllegalArgumentException("'${name.value}' environment variable is blank")
        }
        return value
    }
}