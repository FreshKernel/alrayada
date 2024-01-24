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
  final String developmentIpAddress;

  /// Use firebase emulator when running locally in debug mode
  final bool useDevServer;
}

EnvironmentVariables getEnvironmentVariables() => EnvironmentVariables(
      developmentIpAddress: dotenv.get('DEVELOPMENT_IP_ADDRESS'),
      useDevServer: bool.parse(dotenv.get('USE_DEV_SERVER')),
    );
