import 'dart:io';

import 'package:open_file/open_file.dart';

class ExportGameHelper {
  static String idGame = Platform.isAndroid ? "com.studio27.MelonPlayground" : "com.TwentySeven.MelonPlayground";

  static Future<OpenResult> openWith(String path) async {
    print("=> open file with: $path");
    return await OpenFile.open(path, uti: idGame);
  }
}
