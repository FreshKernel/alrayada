import 'package:flutter/widgets.dart' show BuildContext;

import '../../data/user/models/user.dart';
import 'notifications.dart';
import 'notifications_impl.dart';

class NotificationsService implements NotificationsImpl {
  NotificationsService._();

  static final instanse = NotificationsService._();
  final Notifications _service = NotificationsImpl();

  @override
  Future<UserDeviceNotificationsToken> getUserDeviceToken() =>
      _service.getUserDeviceToken();

  @override
  Future<void> registerNotificationsHandlers(BuildContext context) =>
      _service.registerNotificationsHandlers(context);
}
