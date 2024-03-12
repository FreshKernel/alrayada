package net.freshplatform.di

import io.ktor.server.application.*
import net.freshplatform.data.chat.ChatDataSource
import net.freshplatform.data.chat.datasources.MongoChatDataSource
import net.freshplatform.data.offer.OfferDataSource
import net.freshplatform.data.offer.datasources.MongoOfferDataSource
import net.freshplatform.data.order.OrderDataSource
import net.freshplatform.data.order.datasources.MongoOrderDataSource
import net.freshplatform.data.product.ProductDataSource
import net.freshplatform.data.product_category.ProductCategoryDataSource
import net.freshplatform.data.product_category.datasources.MongoProductCategoryDataSource
import net.freshplatform.data.product.datasources.MongoProductDataSource
import net.freshplatform.data.user.UserDataSource
import net.freshplatform.data.user.datasources.MongoUserDataSource
import net.freshplatform.routes.chat.ChatRoomController
import net.freshplatform.services.mail.JavaMailSenderService
import net.freshplatform.services.mail.MailSenderService
import net.freshplatform.services.notifications.NotificationService
import net.freshplatform.services.notifications.one_signal.KtorOneSignalNotificationService
import net.freshplatform.services.secret_variables.SecretVariablesName
import net.freshplatform.services.secret_variables.SecretVariablesService
import net.freshplatform.services.security.hashing.HashingService
import net.freshplatform.services.security.hashing.SHA256HashingService
import net.freshplatform.services.security.payment_methods.PaymentMethodsService
import net.freshplatform.services.security.payment_methods.PaymentMethodsServiceImpl
import net.freshplatform.services.security.social_authentication.SocialAuthenticationService
import net.freshplatform.services.security.social_authentication.SocialAuthenticationServiceImpl
import net.freshplatform.services.security.token.JwtService
import net.freshplatform.services.security.token.JwtServiceImpl
import net.freshplatform.services.security.verification_token.TokenVerificationService
import net.freshplatform.services.security.verification_token.TokenVerificationServiceImpl
import net.freshplatform.services.telegram.KtorTelegramBotService
import net.freshplatform.services.telegram.TelegramBotService
import net.freshplatform.utils.constants.Constants
import org.koin.dsl.module
import org.koin.ktor.plugin.Koin
import org.litote.kmongo.coroutine.coroutine
import org.litote.kmongo.reactivestreams.KMongo

fun Application.dependencyInjection() {
    install(Koin) {
        modules(mainModule, servicesModule, dataSourcesModule)
    }
}

val mainModule = module {
    single {
        val databaseUrl = SecretVariablesService.require(SecretVariablesName.DatabaseUrl)
        KMongo.createClient(
            connectionString = databaseUrl,
        )
            .coroutine
            .getDatabase(Constants.APP_DATABASE_NAME)
    }
}

val servicesModule = module {
    single<JwtService> {
        JwtServiceImpl()
    }
    single<HashingService> {
        SHA256HashingService()
    }
    single<TokenVerificationService> {
        TokenVerificationServiceImpl()
    }
    single<MailSenderService> {
        JavaMailSenderService()
    }
    single<TelegramBotService> {
        KtorTelegramBotService()
    }
    single<NotificationService> {
        KtorOneSignalNotificationService()
//        KtorFcmNotificationService()
    }
    single<SocialAuthenticationService> {
        SocialAuthenticationServiceImpl()
    }
    single<PaymentMethodsService> {
        PaymentMethodsServiceImpl()
    }
}

val dataSourcesModule = module {
    single<UserDataSource> {
        MongoUserDataSource(get())
    }
    single<ProductCategoryDataSource> {
        MongoProductCategoryDataSource(get())
    }
    single<ProductDataSource> {
        MongoProductDataSource(get(), get())
    }
    single<OrderDataSource> {
        MongoOrderDataSource(get())
    }
    single<ChatDataSource> {
        MongoChatDataSource(get())
    }
    single {
        ChatRoomController(get(), get(), get(), get())
    }
    single<OfferDataSource> {
        MongoOfferDataSource(get())
    }
}