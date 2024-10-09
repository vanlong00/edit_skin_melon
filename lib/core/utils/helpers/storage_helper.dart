import 'package:path_provider/path_provider.dart';
import 'dart:io';

class StorageHelper {
  static Future<Directory> getSavedDirectory() async {
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory() //FOR ANDROID
        : await getApplicationDocumentsDirectory();

    if (directory == null && !directory!.existsSync()) {
      throw Exception('Failed to get directory');
    }

    return directory;
  }
}