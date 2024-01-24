import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kDebugMode, kIsWeb;

import 'env.dart';

/// Configurations for the app server
class ServerConfigurations {
  const ServerConfigurations._();

  static var baseUrl = getProductionBaseUrl();

  static const _defaultPort = 8080;

  static String getProductionBaseUrl() {
    // TODO: Implement
    throw UnimplementedError();
  }

  static Future<String> getDevelopmentBaseUrl() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    if (!kIsWeb) {
      if (defaultTargetPlatform == TargetPlatform.android &&
          !(await deviceInfoPlugin.androidInfo).isPhysicalDevice) {
        return 'http://10.0.2.2:$_defaultPort';
      }
      if (defaultTargetPlatform == TargetPlatform.iOS &&
          !(await deviceInfoPlugin.iosInfo).isPhysicalDevice) {
        return 'http://localhost:$_defaultPort';
      }
    }
    return getEnvironmentVariables().developmentIpAddress;
  }

  static Future<String> getBaseUrl() async {
    if (kDebugMode) {
      return getDevelopmentBaseUrl();
    }
    return getProductionBaseUrl();
  }

  /// This add the base url to the path of the route
  static String getRequestUrl(String path) {
    return '$baseUrl/$path';
  }
}
