package net.freshplatform.services.secret_variables

interface SecretVariables {
    fun getString(name: SecretVariablesName): String?
    fun getString(name: SecretVariablesName, defaultValue: String): String
    fun require(name: SecretVariablesName): String
}