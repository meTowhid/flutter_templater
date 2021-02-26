library flutter_templater;

import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:flutter_templater/constants.dart';
import 'package:flutter_templater/custom_exceptions.dart';
import 'package:flutter_templater/fetch_gist.dart';
import 'package:flutter_templater/script.dart' as script;
import 'package:flutter_templater/template_config_model.dart';
import 'package:yaml/yaml.dart';

Future<void> runFromArguments(List<String> arguments) async {
  final parser = ArgParser()
    ..addFlag(Constant.helpFlag, abbr: 'h', help: 'Usage help', negatable: false)
    ..addOption(Constant.fileOption, abbr: 'f', help: 'Config file (default: ${Constant.defaultConfigFile})');
  final argResults = parser.parse(arguments);

  if (argResults[Constant.helpFlag] == true) {
    stdout.writeln('Generates project folder structure and template files');
    stdout.writeln(parser.usage);
    exit(0);
  }
  // Load the config file
  final templateConfig = loadConfigDataFromArgResults(argResults, verbose: true);

  // try to generate from local file
  try {
    if (templateConfig.configElements.isNotEmpty) {
      await script.run(templateConfig);
      print('\n✓ Generated Successfully');
    }
  } catch (e) {
    stderr.writeln(e);
    exit(2);
  }

  // generate from gist
  try {
    final gistLink = templateConfig.gist;
    if (isValidGistLink(gistLink)) {
      print('FETCHING GIST -> $gistLink');
      final yamlConfigFromGist = await fetchGistContent(gistLink);
      if (yamlConfigFromGist.isNotEmpty == true) {
        final config = parseYamlConfigFile(yamlConfigFromGist, gistLink);
        await script.run(config);
        print('\n✓ Generated Successfully');
      }
    } else {
      print('INVALID GIST -> $gistLink');
    }
  } catch (e) {
    print('INVALID CONFIG IN GIST -> ${templateConfig.gist}');
    stderr.writeln(const InvalidConfigException('Invalid config file'));
    exit(1);
  }
}

TemplateConfig loadConfigDataFromArgResults(ArgResults argResults, {bool verbose}) {
  verbose ??= false;
  final configFile = argResults[Constant.fileOption] as String;
  final fileOptionResult = argResults[Constant.fileOption] as String;

  try {
    final file = File(configFile ?? Constant.defaultConfigFile);
    final yamlString = file.readAsStringSync();
    return parseYamlConfigFile(yamlString, fileOptionResult);
  } catch (e) {
    if (verbose) {
      stderr.writeln(e);
    }
    return null;
  }
}

TemplateConfig parseYamlConfigFile(String yamlString, String fileOptionResult) {
  final yamlMap = loadYaml(yamlString) as YamlMap;

  final jsonString = json.encode(yamlMap);
  final asJson = json.decode(jsonString) as Map<String, dynamic>;

  return TemplateConfig.fromJson(asJson[Constant.templateConfig] as Map<String, dynamic>);
}
