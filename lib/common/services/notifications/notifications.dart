import 'package:flutter/widgets.dart';

import '../../../auth/data/models/user.dart';

// TODO: This and related classes should be renamed
abstract class Notifications {
  Future<void> registerNotificationsHandlers(BuildContext context);
  Future<UserDeviceNotificationsToken> getUserDeviceToken();
}
