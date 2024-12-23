import 'dart:developer';
import 'dart:io';

import 'package:open_file/open_file.dart';

class ExportGameHelper {
  static final String _idGame = Platform.isAndroid ? "com.studio27.MelonPlayground" : "com.TwentySeven.MelonPlayground";

  static Future<OpenResult> openWith(String path) async {
    log("=> open file with: $path");
    return await OpenFile.open(path, uti: _idGame);
  }
}
