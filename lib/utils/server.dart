import 'dart:io' show Platform;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Configurations for the app server
class ServerConfigurations {
  const ServerConfigurations._();

  static const _defaultPort = 8080;

  static String getProductionBaseUrl() {
    return dotenv.get('PRODUCTION_URL');
  }

  static Future<String> getDevelopmentBaseUrl() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    if (!kIsWeb) {
      if (Platform.isAndroid &&
          !(await deviceInfoPlugin.androidInfo).isPhysicalDevice) {
        return 'http://10.0.2.2:$_defaultPort';
      }
      if (Platform.isIOS &&
          !(await deviceInfoPlugin.iosInfo).isPhysicalDevice) {
        return 'http://localhost:$_defaultPort';
      }
    }
    return dotenv.get('DEVELOPMENT_URL');
  }

  static Future<String> getBaseUrl() async {
    if (kDebugMode) {
      return getDevelopmentBaseUrl();
    }
    return getProductionBaseUrl();
  }

  /// This add the base url to the path of the route
  static Future<String> getRequestUrl(String path) async {
    final url = await getBaseUrl();
    return '$url/api/$path';
  }
}
