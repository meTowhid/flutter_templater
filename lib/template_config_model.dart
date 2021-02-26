class TemplateConfig {
  const TemplateConfig({this.gist, this.override, this.configElements});

  factory TemplateConfig.fromJson(Map<String, dynamic> json) => TemplateConfig(
        gist: json['gist'] as String,
        override: (json['override'] as bool) ?? false,
        configElements: json['generate'] == null
            ? []
            : List<ConfigElement>.from((json['generate'] as List).map((x) {
                return ConfigElement.fromJson(x as Map<String, dynamic>);
              })),
      );

  final String gist;
  final bool override;
  final List<ConfigElement> configElements;

  // @override
  String toString() {
    return 'TemplateConfig{gist: $gist, override: $override, configElements: $configElements}';
  }
}

class ConfigElement {
  const ConfigElement({this.path, this.gist, this.template, this.files});

  factory ConfigElement.fromJson(Map<String, dynamic> json) => ConfigElement(
        path: json['path'] as String,
        gist: json['gist'] as String,
        template: json['template'] as String,
        files: json['files'] == null
            ? []
            : List<FileElement>.from((json['files'] as List).map((x) {
                return FileElement.fromJson(x as Map<String, dynamic>);
              })),
      );

  final String path, template, gist;
  final List<FileElement> files;

  @override
  String toString() {
    return 'ConfigElement{path: $path, template: $template, gist: $gist, files: $files}';
  }
}

class FileElement {
  const FileElement({this.file, this.gist, this.template});

  factory FileElement.fromJson(Map<String, dynamic> json) => FileElement(
        file: json['file'] as String,
        gist: json['gist'] as String,
        template: json['template'] as String,
      );

  final String file, gist, template;

  @override
  String toString() {
    return 'FileElement{file: $file, gist: $gist, template: $template}';
  }
}
