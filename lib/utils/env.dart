import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:meta/meta.dart';

@immutable
class EnvironmentVariables {
  const EnvironmentVariables({
    required this.developmentIpAddress,
    required this.useDevServer,
  });

  /// Example 192.168.0.151, used when the running device is not an emulator
  /// for connecting to firebase emulator or local backend app
  ///
  /// The reason why this is the ip address instead of the base url
  /// is that on Android emulator we always use 10.0.2.2 and on
  /// iOS simulator localhost
  ///
  /// otherwise will use [developmentIpAddress]
  ///
  /// the [useDevServer] must be true
  final String developmentIpAddress;

  /// If true then we will use [developmentIpAddress]
  /// this will only work when running in debug mode
  /// of the flutter app [kDebugMode]
  final bool useDevServer;
}

EnvironmentVariables getEnvironmentVariables() => EnvironmentVariables(
      developmentIpAddress: dotenv.get('DEVELOPMENT_IP_ADDRESS'),
      useDevServer: bool.parse(dotenv.get('USE_DEV_SERVER')),
    );
