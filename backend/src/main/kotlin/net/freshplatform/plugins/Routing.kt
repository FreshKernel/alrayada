package net.freshplatform.plugins

import io.ktor.http.*
import io.ktor.serialization.*
import io.ktor.server.application.*
import io.ktor.server.http.content.*
import io.ktor.server.plugins.*
import io.ktor.server.plugins.statuspages.*
import io.ktor.server.request.ContentTransformationException
import io.ktor.server.resources.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import kotlinx.serialization.SerializationException
import net.freshplatform.data.chat.ChatDataSource
import net.freshplatform.data.offer.OfferDataSource
import net.freshplatform.data.order.OrderDataSource
import net.freshplatform.data.product.ProductDataSource
import net.freshplatform.data.product_category.ProductCategoryDataSource
import net.freshplatform.data.user.UserDataSource
import net.freshplatform.routes.chat.ChatRoomController
import net.freshplatform.routes.chat.ChatRoutes
import net.freshplatform.routes.chat.admin.ChatAdminRoutes
import net.freshplatform.routes.offers.OfferRoutes
import net.freshplatform.routes.orders.OrderRoutes
import net.freshplatform.routes.orders.admin.OrderAdminRoutes
import net.freshplatform.routes.orders.payment_gateways.PaymentGatewaysRoutes
import net.freshplatform.routes.product.ProductRoutes
import net.freshplatform.routes.product.category.ProductCategoryRoutes
import net.freshplatform.routes.user.UserRoutes
import net.freshplatform.routes.user.admin.UserAdminRoutes
import net.freshplatform.services.mail.MailSenderService
import net.freshplatform.services.notifications.NotificationService
import net.freshplatform.services.security.hashing.HashingService
import net.freshplatform.services.security.payment_methods.PaymentMethodsService
import net.freshplatform.services.security.social_authentication.SocialAuthenticationService
import net.freshplatform.services.security.token.JwtService
import net.freshplatform.services.security.verification_token.TokenVerificationService
import net.freshplatform.services.telegram.TelegramBotService
import net.freshplatform.utils.ErrorResponse
import net.freshplatform.utils.ErrorResponseException
import net.freshplatform.utils.constants.Constants
import net.freshplatform.utils.constants.DomainVerificationConstants
import net.freshplatform.utils.extensions.getFileFromUserWorkingDirectory
import net.freshplatform.utils.extensions.request.*
import org.koin.ktor.ext.inject

fun Application.configureRouting() {
    val jwtService by inject<JwtService>()
    val hashingService by inject<HashingService>()
    val tokenVerificationService by inject<TokenVerificationService>()
    val mailSenderService by inject<MailSenderService>()
    val telegramBotService by inject<TelegramBotService>()
    val notificationService by inject<NotificationService>()
    val socialAuthenticationService by inject<SocialAuthenticationService>()
    val paymentMethodsService by inject<PaymentMethodsService>()

    val userDataSource by inject<UserDataSource>()
    val productDataSource by inject<ProductDataSource>()
    val productCategoryDataSource by inject<ProductCategoryDataSource>()
    val orderDataSource by inject<OrderDataSource>()
    val chatDataSource by inject<ChatDataSource>()
    val offerDataSource by inject<OfferDataSource>()

    install(StatusPages) {
        exception<Throwable> { _, cause ->
            cause.printStackTrace()
            throw ErrorResponseException(HttpStatusCode.InternalServerError, "500: $cause", "SERVER_ERROR")
        }
        exception<SerializationException> { call, cause ->
            throw ErrorResponseException( HttpStatusCode.BadRequest, "Invalid json: $cause", "INVALID_JSON")
        }
        exception<IllegalArgumentException> { call, cause ->
            call.respondJsonText(text = "Invalid: $cause", status = HttpStatusCode.BadRequest)
        }
        exception<ContentTransformationException> { call, cause ->
            call.respondJsonText(HttpStatusCode.BadRequest, "Invalid request format: ${cause.message}")
        }
        exception<BadRequestException> { call, cause ->
            call.respondJsonText(HttpStatusCode.BadRequest, "Bad request: ${cause.message}")
        }
        exception<RouteProtectedException> { call, _ ->
            call.respondJsonText(HttpStatusCode.Unauthorized, "You don't have access to this api")
        }
        exception<JsonConvertException> { call, cause ->
            call.respondJsonText(HttpStatusCode.InternalServerError, "Error while convert json = ${cause.message}")
        }
        exception<UserShouldAuthenticatedException> { call, cause ->
            call.respondJsonText(HttpStatusCode.BadRequest, cause.message.toString())
        }
        exception<RequestBodyMustValidException> { call, cause ->
            call.respondJsonText(HttpStatusCode.BadRequest, cause.message.toString())
        }
        exception<ErrorResponseException> { call, cause ->
            call.respond(
                message = ErrorResponse(
                    message = cause.message,
                    code = cause.code,
                    data = cause.data
                ),
                status = cause.status,
            )
        }
    }
    install(Resources)

    routing {
        route("/.well-known") {
            route("/apple-app-site-association") {
                handle {
                    call.respondText(
                        status = HttpStatusCode.OK,
                        text = DomainVerificationConstants.APPLE.JSON_DATA,
                        contentType = ContentType.Application.Json
                    )
                }
            }
            route("/assetlinks.json") {
                handle {
                    call.respondText(
                        status = HttpStatusCode.OK,
                        text = DomainVerificationConstants.Google.JSON_DATA,
                        contentType = ContentType.Application.Json
                    )
                }
            }
        }

        get("/getServerClientUrl") {
            val baseUrl = call.getServerClientUrl()
            call.respondJsonText(HttpStatusCode.OK, baseUrl)
        }

        route("/api") {
            route("/support") {
                val chatRoomController by inject<ChatRoomController>()
                val chatRoutes = ChatRoutes(this, chatDataSource, chatRoomController)
                chatRoutes.userChat()

                route("/admin") {
                    val chatAdminRoutes = ChatAdminRoutes(this, chatDataSource, userDataSource, chatRoomController)
                    chatAdminRoutes.chat()
                    chatAdminRoutes.getRooms()
                    chatAdminRoutes.deleteRoom()
                    chatAdminRoutes.roomsStatus() // Not used in project
                }
                chatRoutes.loadMessages() // Not used in project
            }
            route("/offers") {
                val offerRoutes = OfferRoutes(this, offerDataSource)
                offerRoutes.getAll()
                offerRoutes.createOne()
                offerRoutes.deleteOne()
            }
            route("/auth") {
                val userRoutes = UserRoutes(
                    this,
                    userDataSource,
                    hashingService,
                    jwtService,
                    tokenVerificationService,
                    mailSenderService,
                    socialAuthenticationService,
                    telegramBotService
                )
                userRoutes.socialAuthentication()
                userRoutes.signInWithAppleWeb()
                userRoutes.signUpWithEmailAndPassword()
                userRoutes.signInWithEmailAndPassword()
                userRoutes.getUserData()
                userRoutes.verifyEmailAccount()
                userRoutes.updateUserData()
                userRoutes.updateDeviceToken()
                userRoutes.forgotPassword()
                userRoutes.resetPasswordForm()
                userRoutes.resetPassword()
                userRoutes.updatePassword()
                userRoutes.deleteSelfAccount()

                val userAdminRoutes = UserAdminRoutes(this, userDataSource, notificationService)
                userAdminRoutes.getAllUsers()
                userAdminRoutes.activateAccount()
                userAdminRoutes.deactivateAccount()
                userAdminRoutes.deleteAccount()
                userAdminRoutes.sendNotification()
            }
            route("/products") {
                route("/categories") {
                    val productCategoryRoutes =
                        ProductCategoryRoutes(this, productCategoryDataSource, productDataSource)
                    productCategoryRoutes.getAll()
                    productCategoryRoutes.getOneById()
                    productCategoryRoutes.createOne()
                    productCategoryRoutes.updateOne()
                    productCategoryRoutes.deleteOne()
                }

                val productRoutes = ProductRoutes(this, productDataSource, productCategoryDataSource)
                productRoutes.getAll()
                productRoutes.getBestSelling()
                productRoutes.getOneById()
                productRoutes.getAllByCategory()
                productRoutes.createOne()
                productRoutes.updateOne()
                productRoutes.deleteOne()
            }
            route("/orders") {
                val orderRoute = OrderRoutes(
                    this, orderDataSource, productDataSource, userDataSource, telegramBotService, paymentMethodsService
                )
                orderRoute.getAll()
                orderRoute.checkout()
                orderRoute.isOrderPaidRoute()
                orderRoute.cancelOrder()
                orderRoute.getStatistics()

                route("/admin") {
                    val orderAdminRoutes = OrderAdminRoutes(this, orderDataSource, userDataSource, notificationService)
                    orderAdminRoutes.deleteOrder()
                    orderAdminRoutes.approveOrder()
                    orderAdminRoutes.rejectOrder()
                }

                route("/paymentGateways") {
                    val paymentGatewaysRoutes = PaymentGatewaysRoutes(this, orderDataSource)
                    paymentGatewaysRoutes.zainCash()
                }

            }
        }
        val filesFolder = "/${Constants.Folders.SERVER_PUBLIC_FILES}/".getFileFromUserWorkingDirectory()
        staticFiles("/", filesFolder)
        staticResources("/", "static")
    }
}
