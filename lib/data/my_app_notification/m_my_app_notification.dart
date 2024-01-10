// import 'dart:convert';

// // import 'package:firebase_messaging/firebase_messaging.dart' show RemoteMessage;

// class MyAppNotification {

//   MyAppNotification({
//     required this.messageId,
//     required this.title,
//     required this.body,
//     required this.imageUrl,
//     required this.data,
//     required this.createdAt,
//   });

//   // factory MyAppNotification.fromFcm(RemoteMessage message) {
//   //   var imageUrl = message.notification?.android?.imageUrl ?? '';
//   //   if (PlatformChecker.isAppleProduct()) {
//   //     imageUrl = message.notification?.apple?.imageUrl ?? '';
//   //   }
//   //   return MyAppNotification(
//   //     messageId: message.messageId ?? '',
//   //     title: message.notification?.title ?? '',
//   //     body: message.notification?.body ?? '',
//   //     imageUrl: imageUrl,
//   //     data: message.data,
//   //     createdAt: DateTime.now(),
//   //   );
//   // }

//   factory MyAppNotification.fromOneSignal(OSNotification notification) {
//     var imageUrl = '';
//     final androidImageUrl =
//         (notification.rawPayload?['bicon'] as String?) ?? '';
//     if (androidImageUrl.isNotEmpty) {
//       imageUrl = androidImageUrl;
//     } else {
//       final iosImageUrl =
//           (notification.rawPayload?['att'] as Map<String, dynamic>?)?['id'] ??
//               '';
//       if (iosImageUrl.isNotEmpty) {
//         imageUrl = iosImageUrl;
//       } else {
//         imageUrl = notification.additionalData?['imageUrl'] ?? '';
//       }
//     }
//     return MyAppNotification(
//       messageId: notification.notificationId,
//       title: notification.title ?? '',
//       body: notification.body ?? '',
//       imageUrl: imageUrl,
//       data: notification.additionalData ?? {},
//       createdAt: DateTime.now(),
//     );
//   }

//   factory MyAppNotification.fromMap(Map<String, dynamic> map) =>
//       MyAppNotification(
//         messageId: map['messageId'] as String,
//         title: map['title'] as String,
//         body: map['body'] as String,
//         imageUrl: map['imageUrl'] as String,
//         data: jsonDecode(map['data']) as Map<String, dynamic>,
//         createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
//       );
//   final String messageId;
//   final String title;
//   final String body;
//   final String imageUrl;
//   final Map<String, dynamic> data;
//   final DateTime createdAt;

//   MyAppNotification copyWith({
//     String? title,
//     String? body,
//     String? imageUrl,
//     Map<String, dynamic>? data,
//   }) =>
//       MyAppNotification(
//         messageId: messageId,
//         title: title ?? this.title,
//         body: body ?? this.body,
//         imageUrl: imageUrl ?? this.imageUrl,
//         data: data ?? this.data,
//         createdAt: createdAt,
//       );

//   Map<String, dynamic> toMap() => {
//         'messageId': messageId,
//         'title': title,
//         'body': body,
//         'imageUrl': imageUrl,
//         'data': jsonEncode(data),
//         'createdAt': createdAt.millisecondsSinceEpoch
//       };
// }
