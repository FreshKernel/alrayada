package net.freshplatform

import io.ktor.client.request.*
import io.ktor.client.statement.*
import io.ktor.http.*
import io.ktor.server.testing.*
import net.freshplatform.di.dependencyInjection
import net.freshplatform.plugins.*
import kotlin.test.Test
import kotlin.test.assertEquals

class ApplicationTest {
    @Test
    fun testRoot() = testApplication {
        application {
            dependencyInjection()
            configureHTTP()
            configureSockets()
            configureSerialization()
            configureMonitoring()
            configureSecurity()
            configureRouting()
        }
        client.get("/").apply {
            assertEquals(HttpStatusCode.OK, status)
            assertEquals("Welcome, to our api!", bodyAsText())
        }
    }
}
