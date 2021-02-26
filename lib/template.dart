enum Template { EmptyClass, Singleton, BasicMain, Scaffold }

extension TemplateExtentions on Template {
  String get code {
    switch (this) {
      case Template.EmptyClass:
        return _emptyClass;
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

  static const _singleton = '''class #CLASS_NAME# {
  #CLASS_NAME#._();

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
