import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class FilePickerHelper {
  static Future<XFile?> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['bin', 'zip'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;

      return file.xFile;
    }
    return null;
  }
}
