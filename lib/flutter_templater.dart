library flutter_templater;

import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:flutter_templater/src/constants.dart';
import 'package:flutter_templater/src/custom_exceptions.dart';
import 'package:flutter_templater/src/fetch_gist.dart';
import 'package:flutter_templater/src/script.dart' as script;
import 'package:flutter_templater/src/template_config_model.dart';
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
      print('\n✓ Generated successfully from local config file');
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
        print('\n✓ Generated successfully from gist');
      } else {
        print('INVALID GIST -> $gistLink');
      }
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
  try {
    final yamlMap = loadYaml(yamlString) as YamlMap;
    final jsonMap = json.decode(json.encode(yamlMap));
    return TemplateConfig.fromJson(jsonMap[Constant.templateConfig] as Map<String, dynamic>);
  } catch (e) {
    stderr.writeln(const InvalidYamlException('Failed to parse YAML data'));
  }
  return null;
}
