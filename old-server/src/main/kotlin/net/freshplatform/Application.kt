package net.freshplatform

import io.ktor.server.application.*
import io.ktor.server.engine.*
import io.ktor.server.netty.*
import net.freshplatform.di.dependencyInjection
import net.freshplatform.plugins.*
import net.freshplatform.services.secret_variables.SecretVariablesName
import net.freshplatform.services.secret_variables.SecretVariablesService
import net.freshplatform.utils.constants.Constants
import net.freshplatform.utils.extensions.getUserWorkingDirectory
import net.freshplatform.utils.extensions.isProductionMode
import net.freshplatform.utils.extensions.isProductionServer

fun main() {
    val server = embeddedServer(
        factory = Netty,
        environment = applicationEngineEnvironment {
            val serverPort =
                SecretVariablesService.getString(
                    SecretVariablesName.ServerPort, Constants.DEFAULT_SERVER_PORT.toString()
                ).toInt()

            developmentMode =
                SecretVariablesService.getString(SecretVariablesName.ServerDevelopmentMode, "true").toBoolean()
            connector { port = serverPort }
            if (developmentMode) {
                watchPaths = listOf("classes", "resources")
            }
            module(Application::module)
        },
    )
    val serverBaseUrl = server.environment.connectors
        .first()
        .let { connector ->
            val scheme = if (connector.type.name == "https") "https" else "http"
            val host = if (connector.host == "0.0.0.0") "localhost" else connector.host
            val port = connector.port

            "$scheme://$host:$port"
        }
    println("Server Base URL: $serverBaseUrl")
    server.start(wait = true)

}

fun Application.module() {
    val serverDevelopmentMode = environment.developmentMode
    println("User directory = ${getUserWorkingDirectory()}")
    println("Server Development mode = $serverDevelopmentMode")
    println("Production mode = ${isProductionMode()}")
    println("Production server = ${isProductionServer()}")

    SecretVariablesName.entries.filter { it.isRequired }.forEach {
        SecretVariablesService.require(it) // Just to throw errors if some of them are not defined
    }

    dependencyInjection()
    configureMonitoring()
    configureSerialization()
    configureSockets()
    configureHTTP()
    configureSecurity()
    configureRouting()
}
