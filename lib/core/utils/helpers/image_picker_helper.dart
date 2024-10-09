import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

class ImagePickerHelper {
  static final _picker = ImagePicker();

  static Future<File?> pickImageFile({double maxWidth = 100, double maxHeight = 100}) async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
    );
    return image == null ? null : File(image.path);
  }

  static Future<Uint8List?> pickImageBytes({double maxWidth = 100, double maxHeight = 100}) async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
    );
    return image == null ? null : await image.readAsBytes();
  }
}