import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class FileDownloaderHelper {
  static Future<void> saveFileAsByteOnDevice(String fileName, Uint8List bytesData) async {
    try {
      if (Platform.isAndroid) {
        // Check if the platform is Android
        final directory = await getDownloadsDirectory();

        if (directory == null || !directory.existsSync()) {
          // Create the directory if it doesn't exist
          await directory?.create();
        }
        final path = '${directory?.path}/$fileName';
        final bytes = bytesData;
        final outFile = File(path);

        if (!outFile.parent.existsSync()) {
          await outFile.create(recursive: true);
        }

        final res = await outFile.writeAsBytes(bytes, flush: true);
        log("=> saved file: ${res.path}");
      } else {
        // IOS
        // final directory = await getApplicationDocumentsDirectory();
        // // Get the application documents directory path
        // final path = '${directory.path}/$fileName';
        // final bytes = await inFile.readAsBytes();
        // final res = await Share.shareXFiles([XFile(path, bytes: bytes)]);
        // log("=> saved status: ${res.status}");
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<void> saveFileAsStringOnDevice(String fileName, String contentData) async {
    try {
      if (Platform.isAndroid) {
        // Check if the platform is Android
        final directory = await getDownloadsDirectory();

        if (directory == null || !directory.existsSync()) {
          // Create the directory if it doesn't exist
          await directory?.create();
        }
        final path = '${directory?.path}/$fileName';
        final content = contentData;
        final outFile = File(path);

        if (!outFile.parent.existsSync()) {
          await outFile.create(recursive: true);
        }

        final res = await outFile.writeAsString(content, flush: true);
        log("=> saved file: ${res.path}");
      } else {
        // IOS
        // final directory = await getApplicationDocumentsDirectory();
        // // Get the application documents directory path
        // final path = '${directory.path}/$fileName';
        // final bytes = await inFile.readAsBytes();
        // final res = await Share.shareXFiles([XFile(path, bytes: bytes)]);
        // log("=> saved status: ${res.status}");
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
