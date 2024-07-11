import 'package:edit_skin_melon/core/di/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<String> getFileFromAssets(String path) async {
  final String fileContents = await rootBundle.loadString(path);
  return fileContents;
}

class AnyFunction {
  static Future<String> loadAsset(String path) async {
    try {
      BuildContext? context = getIt<GlobalKey<NavigatorState>>().currentState?.context;
      return await DefaultAssetBundle.of(context!).loadString(path);
    } catch (e) {
      throw Exception('Error loading asset');
    }
  }
}
