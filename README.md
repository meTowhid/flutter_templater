[![Build Status](https://travis-ci.org/fluttercommunity/flutter_templater.svg?branch=master)](https://travis-ci.org/MarkOSullivan94/flutter_templater) [![pub package](https://img.shields.io/pub/v/flutter_templater.svg)](https://pub.dartlang.org/packages/flutter_templater)

# Flutter Templater

A command-line tool which simplifies the process of creating folder and file structure of your project according to your needs. Your Template Config file can be saved locally or uploaded to your gist account.

## :book: Guide

#### 1. Setup the config file

Add your Flutter Template configuration to your `pubspec.yaml` or create a new config file called `flutter_template_config.yaml`.
An example is shown below. More complex examples [can be found in the example projects](https://github.com/meTowhid/flutter_templater/tree/master/example).
```yaml
dev_dependencies:
  flutter_templater: "^0.0.1"

template_config:
  generate:
    - path: assets/fonts
    - path: lib/constants/constants.dart
    - path: lib/screens
      files:
        - file: splash.dart
          template: scaffold
```
If you stored your configuration separately than you will need to specify the name of the file when running the package.

```
flutter pub get
flutter pub run flutter_templater:main -f <your config file name here>
```

#### 2. Run the package

After setting up the configuration, all that is left to do is run the package. default file name is `pubspec.yaml`

```
flutter pub get
flutter pub run flutter_templater:main
```

If you encounter any issues [please report them here](https://github.com/meTowhid/flutter_templater/issues).


## :mag: Attributes

Shown below is the full list of attributes which you can specify within your Flutter Templater configuration.

- `override`
  - `true`/`false`: Override the existing files

- `gist`: This can pull any 'config.yaml' file from gist address

- `generate`: This holds the list of generatable items

    - `path`: The location of the folder/file. In case of file you can define its template code.

      `template`: 3 basic templates are included in the package `singleton`, `scaffold` and `basicMain`

      `gist`: You can use your own gist to create template

      `files`: In case of generating multiple files in the same directory
       - `file`: file name with its extension must be here

         `template`: as mentioned earlier, any template can be used here

         `gist`: Your gist link can be applied here

