import 'package:flutter/widgets.dart';

import '../../data/user/models/user.dart';

abstract class Notifications {
  Future<void> registerNotificationsHandlers(BuildContext context);
  Future<UserDeviceNotificationsToken> getUserDeviceToken();
}
