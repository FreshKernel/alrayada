package net.freshplatform.plugins

import com.mongodb.kotlin.client.coroutine.MongoClient
import com.mongodb.kotlin.client.coroutine.MongoDatabase
import io.ktor.server.application.*
import net.freshplatform.Constants
import net.freshplatform.utils.getEnvironmentVariables
import org.koin.dsl.module
import org.koin.ktor.ext.inject


val databaseModule = module {
    single<MongoClient> {
        MongoClient.create(
            connectionString = getEnvironmentVariables().mongoConnectionString
        )
    }
    single<MongoDatabase> {
        // We no longer need to update the log level in code because we are doing it in resources/logback.xml file
//        (LoggerFactory.getILoggerFactory() as LoggerContext).getLogger("org.mongodb.driver").level =
//            Level.ERROR

        get<MongoClient>()
            .getDatabase(Constants.DATABASE_NAME)
    }
}

fun Application.configureDatabase() {
    environment.monitor.subscribe(ApplicationStopped) {
        val mongoClient by inject<MongoClient>()
        log.info("Closing the database connection.")
        mongoClient.close()
    }
}