import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

class ImagePickerHelper {
  static final _picker = ImagePicker();

  static Future<XFile?> pickImageFile({double maxWidth = 100, double maxHeight = 100}) async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
    );
    if (image != null) {
      return image;
    }
    return null;
  }

  static Future<List<XFile>> pickMultipleImageFile({double maxWidth = 100, double maxHeight = 100}) async {
    final image = await _picker.pickMultiImage(
      maxWidth: maxWidth,
      maxHeight: maxHeight,
    );
    return image;
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
