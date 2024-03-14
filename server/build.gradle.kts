plugins {
    alias(libs.plugins.kotlin.jvm)
    alias(libs.plugins.kotlinx.serialization)
    alias(libs.plugins.kotlin.ktor)
}

group = "net.freshplatform"
version = "0.0.1"

application {
    mainClass.set("net.freshplatform.ApplicationKt")

    val isDevelopment: Boolean = project.ext.has("development")
    applicationDefaultJvmArgs = listOf("-Dio.ktor.development=$isDevelopment")
}

repositories {
    mavenCentral()
}

dependencies {
    implementation("io.ktor:ktor-server-core-jvm")
    implementation("io.ktor:ktor-server-netty-jvm")
    implementation("io.ktor:ktor-server-websockets-jvm")
    implementation("io.ktor:ktor-server-content-negotiation-jvm")
    implementation("io.ktor:ktor-serialization-kotlinx-json-jvm")
    implementation("io.ktor:ktor-server-call-logging-jvm")
    implementation("io.ktor:ktor-server-http-redirect-jvm")
    implementation("io.ktor:ktor-server-hsts-jvm")
    implementation("io.ktor:ktor-server-default-headers-jvm")
    implementation("io.ktor:ktor-server-cors-jvm")
    implementation("io.ktor:ktor-server-compression-jvm")
    implementation("io.ktor:ktor-server-caching-headers-jvm")
    implementation("io.ktor:ktor-server-host-common-jvm")
    implementation("io.ktor:ktor-server-status-pages-jvm")
    implementation("io.ktor:ktor-server-resources")
    implementation("io.ktor:ktor-server-rate-limit-jvm")
    implementation("io.ktor:ktor-server-auth-jvm")
    implementation("io.ktor:ktor-server-auth-jwt-jvm")
    testImplementation("io.ktor:ktor-server-tests-jvm")
    implementation("ch.qos.logback:logback-classic:${libs.versions.logback.get()}")

    // Ktor Client
    implementation("io.ktor:ktor-client-core")
    implementation("io.ktor:ktor-client-cio")
    implementation("io.ktor:ktor-client-content-negotiation")
    implementation("io.ktor:ktor-client-logging")
    implementation("io.ktor:ktor-serialization-kotlinx-json")

    testImplementation("org.jetbrains.kotlin:kotlin-test-junit:${libs.versions.kotlin.get()}")
    implementation("org.jetbrains.kotlinx:kotlinx-datetime:0.5.0")

    implementation("at.favre.lib:bcrypt:0.10.2")

    implementation("org.mongodb:mongodb-driver-kotlin-coroutine:4.11.0")
    implementation("org.mongodb:bson-kotlinx:4.11.0")

    // Koin
    implementation("io.insert-koin:koin-core:${libs.versions.koin.get()}")
    implementation("io.insert-koin:koin-ktor:${libs.versions.koinKtor.get()}")
    implementation("io.insert-koin:koin-logger-slf4j:${libs.versions.koinKtor.get()}")

    implementation("io.github.cdimascio:dotenv-kotlin:6.4.1")

    implementation("com.google.api-client:google-api-client:1.32.1") // for Google sign in

    implementation("com.sun.mail:jakarta.mail:2.0.1")
    implementation ("com.auth0:jwks-rsa:0.22.1")

    implementation("io.github.smiley4:ktor-swagger-ui:2.7.4")
}

tasks {
    create("stage").dependsOn("installDist")
}