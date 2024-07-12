import 'dart:io' show Directory, File;
import 'package:alrayada/settings/data/settings_data.dart';
import 'package:path/path.dart' as path;

import 'package:test/test.dart';

void main() {
  test('the localizations should be available in the in-app settings',
      () async {
    final appLocalizationNames = AppLocalization.values.asNameMap()
      ..removeWhere((key, value) {
        return value == AppLocalization.system;
      });

    final localizationsDirectory = Directory('lib/common/localizations');
    final localizationFiles =
        await localizationsDirectory.list().where((fileSystemEntity) {
      return fileSystemEntity is File &&
          path.extension(fileSystemEntity.path) == '.arb';
    }).toList();

    expect(localizationFiles.length, appLocalizationNames.length);
  });
}
