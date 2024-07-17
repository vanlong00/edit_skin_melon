import 'dart:convert';

import 'package:edit_skin_melon/core/di/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnyFunction {
  static Future<String> loadAsset(String path) async {
    try {
      BuildContext? context = getIt<GlobalKey<NavigatorState>>().currentState?.context;
      return await DefaultAssetBundle.of(context!).loadString(path);
    } catch (e) {
      throw Exception('Error loading asset');
    }
  }

  static Future<Map<String, dynamic>> loadModsAsset() async {
    try {
      final manifestContent = await rootBundle.loadString('AssetManifest.json');

      return json.decode(manifestContent);
    } catch (e) {
      throw Exception('Error loading asset');
    }
  }
}
