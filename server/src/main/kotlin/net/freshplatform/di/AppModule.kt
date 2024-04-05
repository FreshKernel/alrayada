package net.freshplatform.di

import io.ktor.server.application.*
import net.freshplatform.data.live_chat.LiveChatDataSource
import net.freshplatform.data.live_chat.MongoLiveChatDataSource
import net.freshplatform.data.user.MongoUserDataSource
import net.freshplatform.data.user.UserDataSource
import net.freshplatform.plugins.databaseModule
import net.freshplatform.services.email_sender.DevEmailSenderService
import net.freshplatform.services.email_sender.EmailSenderService
import net.freshplatform.services.email_sender.JavaEmailSenderService
import net.freshplatform.services.ktor_client.HttpService
import net.freshplatform.services.notifications.KtorFcmNotificationsService
import net.freshplatform.services.notifications.NotificationsService
import net.freshplatform.services.security.hashing.BcryptHashingService
import net.freshplatform.services.security.hashing.JavaBcryptBcryptHashingService
import net.freshplatform.services.security.jwt.JwtService
import net.freshplatform.services.security.jwt.JwtServiceImpl
import net.freshplatform.services.security.social_login.SocialLoginService
import net.freshplatform.services.security.social_login.SocialLoginServiceImpl
import net.freshplatform.services.security.token_verification.JavaTokenVerificationService
import net.freshplatform.services.security.token_verification.TokenVerificationService
import net.freshplatform.services.telegram_bot.KtorTelegramBotService
import net.freshplatform.services.telegram_bot.TelegramBotService
import net.freshplatform.utils.getEnvironmentVariables
import org.koin.dsl.module
import org.koin.ktor.plugin.Koin
import org.koin.logger.slf4jLogger

fun Application.dependencyInjection() {
    install(Koin) {
        slf4jLogger()
        modules(databaseModule, servicesModule, dataSourcesModule)
    }
}

val servicesModule = module {
    single<BcryptHashingService> {
        JavaBcryptBcryptHashingService()
    }
    single<EmailSenderService> {
        if (getEnvironmentVariables().isProductionMode) {
            JavaEmailSenderService()
        } else {
            DevEmailSenderService()
        }
    }
    single<TelegramBotService> {
        KtorTelegramBotService(HttpService.client)
    }
    single<TokenVerificationService> {
        JavaTokenVerificationService()
    }
    single<JwtService> {
        JwtServiceImpl()
    }
    single<SocialLoginService> {
        SocialLoginServiceImpl()
    }
    single<NotificationsService> {
        KtorFcmNotificationsService(HttpService.client)
    }
}

val dataSourcesModule = module {
    single<UserDataSource> {
        MongoUserDataSource(get())
    }
    single<LiveChatDataSource> {
        MongoLiveChatDataSource(get())
    }
}