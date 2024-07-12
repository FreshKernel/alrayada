package net.freshplatform

import io.ktor.server.application.*
import io.ktor.server.engine.*
import io.ktor.server.netty.*
import net.freshplatform.di.configureDependencyInjection
import net.freshplatform.plugins.configureDatabase
import net.freshplatform.plugins.configureHTTP
import net.freshplatform.plugins.configureMonitoring
import net.freshplatform.plugins.configureRouting
import net.freshplatform.plugins.configureSecurity
import net.freshplatform.plugins.configureSerialization
import net.freshplatform.plugins.configureSockets
import net.freshplatform.utils.getEnvironmentVariables
import java.net.NetworkInterface

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
        log.info("Server Local Address: http://${
            NetworkInterface.getNetworkInterfaces().asSequence()
                .flatMap { it.inetAddresses.asSequence() }
                .filter { !it.isLoopbackAddress && it.isSiteLocalAddress }
                .firstOrNull()?.hostAddress
        }:${environment.config.port}")
    }
    configureDependencyInjection()
    configureDatabase()
    configureHTTP()
    configureSockets()
    configureSerialization()
    configureMonitoring()
    configureSecurity()
    configureRouting()
}
