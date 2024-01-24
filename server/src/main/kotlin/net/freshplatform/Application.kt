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
        watchPaths = listOf("classes", "resources")
    )
        .start(wait = true)
}

fun Application.module() {
    dependencyInjection()
    configureHTTP()
    configureSockets()
    configureSerialization()
    configureMonitoring()
    configureSecurity()
    configureRouting()
}
