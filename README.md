# Alrayada

An ecommerce application developed by Fresh Platform for Alrayada company.

[![style: effective dart](https://img.shields.io/badge/style-effective_dart-40c4ff.svg)](https://dart.dev/effective-dart)

## Table of contents
- [Alrayada](#alrayada)
  - [Table of contents](#table-of-contents)
  - [Build](#build)
  - [Third party Apis](#third-party-apis)
  - [Todos](#todos)

## Build

1. First of all you need to setup the [Server](./server/README.md)
2. Create a file called `.env` and copy the content of `fallback.env` into this newly created file
3. Provide the values, if you can't understand some of the variables, go to
   this [File](./lib/utils/env.dart)
4. Change the values in the [Constants](./lib/constants.dart) file
5. Setup App Signing for both Android and iOS
6. Setup Firebase using [Firebase Flutter CLI](https://firebase.google.com/docs/flutter/setup)
7. Setup the [Apis](#third-party-apis)
8. Setup App Links for both Android and iOS

## Third party Apis

1. Social Login:
   1. Google: Enable the sign in with google in the firebase project after adding the client apps and signing them, for more info visit the [google_sign_in](https://pub.dev/packages/google_sign_in) plugin, also use the google client id for each platform in the server `.env` file for sign in with google to work
   2. Apple: TODO: 
2. Firebase Messaging for notifications: No configurations required
3. For location by ip address ipapi.co: No configurations required

## Todos

 <!-- TODO: Finish all the todos -->

1. I might add a way to choose whatever to enter already existing user auth form inputs data on debug mode only for development mode
2. Make that when the user open the notification it will navigate to the correct screen, for example when the user account is activated, then trigger the code to update the state
3. I might add profile picture upload so users with email and password can benefit from it
4. I might create a image widget that share common code such as error handling and loading indiactor. Update: Already done but it needs futher update
5. I might create a skeleton widget that share common code for pagination/infinite list to avoid duplication (for categories example)
6. For now, the categories ui in both admin and user dashboard is separated, but I might merge them in one code
7. I should use `semanticLabel` more for accessibility