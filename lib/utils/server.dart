import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

import 'env.dart';

/// Configurations for the app server
class ServerConfigurations {
  const ServerConfigurations._();

  static var baseUrl = getProductionBaseUrl();

  static const _productionBaseUrl = 'https://alrayada.net';

  static String getProductionBaseUrl() {
    return _productionBaseUrl;
  }

  static const _developmentServerPort = 8080;

  static Future<String> getDevelopmentBaseUrl() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    if (!kIsWeb) {
      if (defaultTargetPlatform == TargetPlatform.android &&
          !(await deviceInfoPlugin.androidInfo).isPhysicalDevice) {
        return 'http://10.0.2.2:$_developmentServerPort';
      }
      if (defaultTargetPlatform == TargetPlatform.iOS &&
          !(await deviceInfoPlugin.iosInfo).isPhysicalDevice) {
        return 'http://localhost:$_developmentServerPort';
      }
    }
    return getEnvironmentVariables().developmentIpAddress;
  }

  /// This add the base url to the path of the route
  static String getRequestUrl(String path) {
    return '$baseUrl/$path';
  }
}
