import 'dart:async';
import 'dart:io';

import 'package:flutter_templater/template_config_model.dart';
import 'package:flutter_templater/custom_exceptions.dart';
import 'package:flutter_templater/fetch_gist.dart';
import 'package:flutter_templater/template.dart';
import 'package:flutter_templater/utils.dart';
import 'package:path/path.dart';

bool shouldOverride = false;

Future<void> run(TemplateConfig config) async {
  shouldOverride = config.override;

  final validItems = config.configElements.where((e) => e.path?.isNotEmpty == true).toList();

  if (validItems.isEmpty) {
    stderr.writeln(const InvalidConfigException('No valid path item found'));
    exit(1);
  }

  for (final item in validItems) {
    await _generateFromConfig(item);
  }
  return;
}

Future _generateFromConfig(ConfigElement item) async {
  if (isFilePath(item.path)) {
    await _generateFile(filePath: item.path, template: item.template, gistLink: item.gist);
    return;
  }

  // check if file name is not empty
  final fileItems = item.files.where((e) => e.file?.isNotEmpty == true).toList();
  if (fileItems?.isNotEmpty == true) {
    for (final f in fileItems) {
      final fullPath = join(item.path, f.file);
      await _generateFile(filePath: fullPath, template: f.template, gistLink: f.gist);
    }
  } else {
    // ignore: avoid_slow_async_io
    final doesDirExists = await Directory(item.path).exists();
    if (!doesDirExists) {
      await Directory(item.path).create(recursive: true);
      print('DIR CREATED -> \'${item.path}\'');
    } else {
      print('DIR EXISTS -> \'${item.path}\'');
    }
  }
}

Future _generateFile({String filePath, String template, String gistLink}) async {
  // generate the file
  // ignore: avoid_slow_async_io
  final doesFileExists = await File(filePath).exists();
  // check if the file already exists
  if (doesFileExists) {
    if (shouldOverride == false) {
      print('FILE EXISTS -> \'$filePath\'');
      return;
    } else {
      print('FILE OVERRIDDEN -> \'$filePath\'');
    }
  }

  final createdFile = await File(filePath).create(recursive: true);
  print('FILE CREATED -> \'$filePath\'');

  var contents = isValidGistLink(gistLink) ? await fetchGistContent(gistLink) : _getTemplateContent(template);
  contents ??= Template.EmptyClass.code;

  // convert file_name to class_name and use it to create name the class
  final className = fileNameToClassName(basename(filePath));
  contents = contents.replaceAll('#CLASS_NAME#', className);

  // write the content of the file
  await createdFile.writeAsString(contents);
}

String _getTemplateContent(String templateName) {
  if (templateName?.isNotEmpty == true) {
    return Template.values.firstWhere(
      (t) => t.toString().split('.').last.toLowerCase() == templateName.toLowerCase(),
      orElse: () {
        print('INVALID TEMPLATE NAME -> \'$templateName\'');
        return Template.EmptyClass;
      },
    ).code;
  }
  return null;
}
