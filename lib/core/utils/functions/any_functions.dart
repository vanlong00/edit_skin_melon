import 'package:flutter/services.dart';

Future<String> getFileFromAssets(String path) async {
  final String fileContents = await rootBundle.loadString(path);
  return fileContents;
}