package net.freshplatform.services.http_client

import net.freshplatform.utils.extensions.isProductionMode
import io.ktor.client.*
import io.ktor.client.plugins.*
import io.ktor.client.plugins.cache.*
import io.ktor.client.plugins.contentnegotiation.*
import io.ktor.client.plugins.logging.*
import io.ktor.serialization.kotlinx.json.*
import kotlinx.serialization.json.Json

object HttpService {
    val client: HttpClient by lazy {
        HttpClient {
            install(ContentNegotiation) {
                json(
                    json = Json {
                        encodeDefaults = true
                        isLenient = true
                        allowSpecialFloatingPointValues = true
                        allowStructuredMapKeys = true
                        prettyPrint = false
                        useArrayPolymorphism = false
                        if (isProductionMode()) {
                            ignoreUnknownKeys = true
                        }
                    }
                )
            }
            install(HttpTimeout)
            install(HttpCache)
            install(Logging) {
                level = LogLevel.ALL
            }
        }
    }
}