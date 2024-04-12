package net.freshplatform

import io.ktor.client.request.*
import io.ktor.client.statement.*
import io.ktor.http.*
import io.ktor.server.testing.*
import net.freshplatform.di.dependencyInjection
import net.freshplatform.plugins.configureRouting
import net.freshplatform.plugins.configureSecurity
import net.freshplatform.plugins.configureSerialization
import net.freshplatform.plugins.configureSockets
import kotlin.test.Test
import kotlin.test.assertEquals

class ApplicationTest {
    @Test
    fun testRoot() = testApplication {
        application {
            dependencyInjection()
            configureSockets()
            configureSerialization()
            configureSecurity()
            configureRouting()
        }
        client.get("/").apply {
            assertEquals(HttpStatusCode.OK, status)
            assertEquals("Welcome, to our api!", bodyAsText())
        }
    }
}
