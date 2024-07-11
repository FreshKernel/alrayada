// TODO: Remove since no longer used

// import 'dart:io' show File;

// import 'package:yaml/yaml.dart';

// // Extract data like the app version from pubspec.yaml file into dart code

// void main(List<String> args) async {
//   final pubspecYamlFile = File('./pubspec.yaml');
//   final pubspecYamlContent = await pubspecYamlFile.readAsString();
//   final yamlDocument = loadYaml(pubspecYamlContent) as YamlMap;
//   final version = yamlDocument['version'].toString();
//   final appVersion = version.split('+')[0];
//   final appBuildNumber = version.split('+')[1];
//   final topics = (yamlDocument['topics'] as YamlList?)?.map((e) => "'$e'");

//   final generatedDartFile = '''
// const name = '${yamlDocument['name']}';
// const appVersion = '$appVersion';
// const appBuildNumber = $appBuildNumber;
// const description = '${yamlDocument['description'] ?? ''}';
// const repository = '${yamlDocument['repository'] ?? ''}';
// const homepage = '${yamlDocument['homepage'] ?? ''}';
// const issueTracker = '${yamlDocument['issue_tracker'] ?? ''}';
// const documentation = '${yamlDocument['documentation'] ?? ''}';
// const topics = [${topics?.join(', ') ?? ''}];
// ''';
//   final file = File('./lib/gen/pubspec.g.dart');
//   if (!(await file.exists())) {
//     await file.create(recursive: true);
//   }
//   await file.writeAsString(generatedDartFile);
// }
