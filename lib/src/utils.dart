import 'dart:io';

import 'package:yaml/yaml.dart';

void printStatus(String message) {
  print('• $message');
}

String generateError(Exception e, String error) {
  return '\n✗ ERROR: ${(e).runtimeType.toString()} \n$error';
}

// converts from snake_case to title_case
String fileNameToClassName(String fileName) => fileName
    .split('.')[0] // removing extension
    .split('_') // splitting via _ underscore
    .map((e) => '${e[0].toUpperCase()}${e.substring(1)}') // titleCasing each word
    .join('');

bool isFilePath(String path) => !path.endsWith('/') && path.split('/').last.contains('.');

String get packageVersion {
  final file = File('pubspec.yaml');
  final yamlString = file.readAsStringSync();
  final yamlMap = loadYaml(yamlString) as YamlMap;
  return (yamlMap['version'] as String) ?? '0.0.1';
}
