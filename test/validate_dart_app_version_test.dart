import 'dart:io' show File;

import 'package:alrayada/common/gen/pubspec.g.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart' show loadYaml, YamlMap;

void main() {
  test(
    'the version in pubspec.yaml file should be up to date with the generated Pubspec class in dart code',
    () async {
      final pubspecYamlContent = await File('pubspec.yaml').readAsString();
      expect(
        Pubspec.versionFull,
        (loadYaml(pubspecYamlContent) as YamlMap)['version'].toString(),
      );
    },
  );
}
