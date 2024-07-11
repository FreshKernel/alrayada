import 'dart:io' show Process;

import 'package:alrayada/firebase_options.dart';

Future<void> main(List<String> args) async {
  await Process.run(
    'dart',
    ['run', 'build_runner' 'build', '--delete-conflicting-outputs'],
  );
  const debugInfoPath = './build/app/outputs/bundle/release';
  await Process.run(
    'flutter',
    ['build', 'appbundle', '--obfuscate', '--split-debug-info=$debugInfoPath'],
  );
  await Process.run(
    'firebase',
    [
      'crashlytics:symbols:upload',
      '--app=${DefaultFirebaseOptions.android.appId}',
      debugInfoPath
    ],
  );
}
