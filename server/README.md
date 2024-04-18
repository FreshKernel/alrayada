# Alrayada Backend

A server application for the client app

## Build

1. First of all, create a file called `.env` and copy the content of `fallback.env` into this newly created file
2. Provide the values, if you can't understand some of the variables, go to
   this [File](./src/main/kotlin/net/freshplatform/utils/EnvironmentVariablesUtils.kt)
3. Change the values in the [Constants](./src/main/kotlin/net/freshplatform/Constants.kt) file
4. Run or package the app, for more info visit the official [Ktor Documentation](https://ktor.io/docs/)

## Third party Apis

1. [Telegram bot](https://core.telegram.org/bots/api)
2. [Google](https://developers.google.com/identity/sign-in/ios/backend-auth) and [Apple sign in](https://developer.apple.com/sign-in-with-apple/get-started/)
3. [Firebase Cloud Messaging](https://firebase.google.com/docs/cloud-messaging) for notifications
4. Payment methods like [Zain Cash](https://docs.zaincash.iq)

## Todos

1. TODO: Optimize the server database operations performance by getting only what we need, for example in the
   sendNotificationsToUser
   route, by getting only what we need (userDeviceNotifications property in this case), there is no need to get the
   whole user, take a look
   at the usages of findUserById() and findUserByEmail()
2. Try to not use `unsafe {}` in Html builders
3. Fix the Live chat sorting issue
4. The `User` and `LiveChat` models naming must be clear whatever if it's a Response, Database or Request model for each
   one, also decide whatever if I should update them to be the same as Product Category pattern, where I create
   the instance of the database user for example inside the impl itself and not in the routes
5. The `LiveChatDataSource` might need some changes, also the models (right now it's required to use default values 
for some parameters in order to fix some bug, I will decide later
6. Update the server code later to try to follow the rest api rules when possible, change the http method and status codes
and the route paths
7. In the future I might make services for the routes like `UserRoutes` or `ProductCategoryRoutes` to share common code
Again, the Route files should only contain `Route` functions and not functions that share common code
8. The extension function `authenticate` in the routes, made the nesting unnecessarily complex, I might change that
9. I might need to improve the way I handle the errors using `Result` by `.getOrElse {}`