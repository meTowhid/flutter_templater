import 'package:flutter_templater/flutter_templater.dart' as templater;
import 'package:flutter_templater/src/utils.dart';

void main(List<String> arguments) {
  print('''
  ═════════════════════════════════
     FLUTTER TEMPLATER (v$packageVersion)                               
  ═════════════════════════════════
  ''');

  templater.runFromArguments(arguments);
}
