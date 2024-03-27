# Alrayada Backend

A server application for the client app

## Build

1. First of all, create a file called `.env` and copy the content of `fallback.env` into this newly created file
2. Provide the values, if you can't understand some of the variables, go to
   this [file](./src/main/kotlin/net/freshplatform/utils/EnvironmentVariablesUtils.kt)
3. Change the values in the [Constants](./src/main/kotlin/net/freshplatform/Constants.kt) file
4. Run or package the app, for more info visit the [official Ktor docs](https://ktor.io/docs/)

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
