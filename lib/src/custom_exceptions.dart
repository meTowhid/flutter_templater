import 'package:flutter_templater/src/utils.dart';

class InvalidYamlException implements Exception {
  const InvalidYamlException([this.message]);

  final String message;

  @override
  String toString() {
    return generateError(this, message);
  }
}

class InvalidGistUrlException implements Exception {
  const InvalidGistUrlException([this.message]);

  final String message;

  @override
  String toString() {
    return generateError(this, message);
  }
}

class InvalidConfigException implements Exception {
  const InvalidConfigException([this.message]);

  final String message;

  @override
  String toString() {
    return generateError(this, message);
  }
}

class NoConfigFoundException implements Exception {
  const NoConfigFoundException([this.message]);

  final String message;

  @override
  String toString() {
    return generateError(this, message);
  }
}
