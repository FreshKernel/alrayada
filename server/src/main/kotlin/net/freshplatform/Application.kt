package net.freshplatform

import io.ktor.server.application.*
import io.ktor.server.engine.*
import io.ktor.server.netty.*
import net.freshplatform.di.dependencyInjection
import net.freshplatform.plugins.*
import net.freshplatform.utils.getEnvironmentVariables

fun main() {
    embeddedServer(
        Netty,
        port = getEnvironmentVariables().serverPort,
        module = Application::module,
        watchPaths = listOf("classes")
    )
        .start(wait = true)
}

fun Application.module() {
    log.info("User directory: ${System.getProperty("user.dir")}")
    getEnvironmentVariables().apply {
        log.info("Production mode: $isProductionMode")
        log.info("Production server: $isProductionServer")
    }
    dependencyInjection()
    configureHTTP()
    configureSockets()
    configureSerialization()
    configureMonitoring()
    configureSecurity()
    configureRouting()
}
