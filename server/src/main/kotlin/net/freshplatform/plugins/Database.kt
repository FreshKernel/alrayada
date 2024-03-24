package net.freshplatform.plugins

import com.mongodb.kotlin.client.coroutine.MongoClient
import com.mongodb.kotlin.client.coroutine.MongoDatabase
import net.freshplatform.Constants
import net.freshplatform.utils.getEnvironmentVariables
import org.koin.dsl.module


val databaseModule = module {
    single<MongoDatabase> {
//        (LoggerFactory.getILoggerFactory() as LoggerContext).getLogger("org.mongodb.driver").level =
//            Level.ERROR

        MongoClient
            .create(connectionString = getEnvironmentVariables().mongoConnectionString)
            .getDatabase(Constants.DATABASE_NAME)
    }
}