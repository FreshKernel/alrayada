package net.freshplatform.plugins

import com.mongodb.kotlin.client.coroutine.MongoClient
import com.mongodb.kotlin.client.coroutine.MongoDatabase
import net.freshplatform.utils.Constants
import net.freshplatform.utils.getEnvironmentVariables
import org.koin.dsl.module

val databaseModule = module {
    single<MongoDatabase> {
        MongoClient
            .create(connectionString = getEnvironmentVariables().mongoConnectionString)
            .getDatabase(Constants.DATABASE_NAME)
    }
}