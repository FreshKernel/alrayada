# Alrayada

An ecommerce application developed by Fresh Platform for Alrayada company.

## Build

1. First of all you need to setup the [Server](./server/README.md)
2. Create a file called `.env` and copy the content of `fallback.env` into this newly created file
3. Provide the values, if you can't understand some of the variables, go to
   this [File](./lib/utils/env.dart)
4. Change the values in the [Constants](./lib/constants.dart) file
5. Setup Firebase using [Firebase Flutter CLI](https://firebase.google.com/docs/flutter/setup)
6. Setup the [Apis](#third-party-apis)
7. Setup App Links on both Android and iOS

## Third party Apis

1. Social Login:
   1. Google: Enable the sign in with google in the firebase project after adding the client apps and signing them, for more info visit the [google_sign_in](https://pub.dev/packages/google_sign_in) plugin, also use the google client id for each platform in the server `.env` file for sign in with google to work
   2. Apple: TODO: 
2. Firebase Messaging for notifications: No configurations required
3. For location by ip address ipapi.co: No configurations required