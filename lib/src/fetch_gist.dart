import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

bool isValidGistLink(String link) =>  link?.contains('gist.github.com') == true;

Future<String> fetchGistContent(String gistLink) async {
  final gistId = gistLink.split('/').last;
  final response = await http.get('https://api.github.com/gists/$gistId');

  if (response.statusCode == HttpStatus.notFound) {
    print('FETCHING GIST FAILED -> ${response.body}');
    return null;
  }

  final data = json.decode(response.body) as Map;
  String content;
  try {
    content = data['files'].values.first['content'] as String;
  } catch (e) {
    print('INVALID GIST CONTENT -> $e');
  }
  return content;
}
