enum Template { EmptyClass, StaticClass, Singleton, BasicMain, Scaffold }

extension TemplateExtentions on Template {
  String get code {
    switch (this) {
      case Template.EmptyClass:
        return _emptyClass;
        break;
      case Template.StaticClass:
        return _staticClass;
        break;
      case Template.Singleton:
        return _singleton;
        break;
      case Template.BasicMain:
        return _basicMain;
        break;
      case Template.Scaffold:
        return _scaffold;
        break;
      default:
        return _emptyClass;
    }
  }

  static const _emptyClass = '''class #CLASS_NAME# {

}''';

  static const _staticClass = '''class #CLASS_NAME# {
  #CLASS_NAME#._();

}
''';

  static const _singleton = '''class #CLASS_NAME# {
  static final #CLASS_NAME# _instance = #CLASS_NAME#._internal();

  factory #CLASS_NAME#() {
    return _instance;
  }

  #CLASS_NAME#._internal();
}
''';

  static const _basicMain = '''
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SampleWidget());
  }
}

class SampleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}''';

  static const _scaffold = '''
import 'package:flutter/material.dart';

class #CLASS_NAME# extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container());
  }
}
''';
}
