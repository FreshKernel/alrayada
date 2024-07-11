import 'dart:io' show File;

import 'package:alrayada/gen/pubspec.g.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart' show loadYaml, YamlMap;

void main() {
  test(
    'make sure the version in pubspec.yaml is up to date with the generated Pubspec in dart code',
    () async {
      final pubspecYamlContent = await File('pubspec.yaml').readAsString();
      expect(
        Pubspec.versionFull,
        (loadYaml(pubspecYamlContent) as YamlMap)['version'].toString(),
      );
    },
  );
}
