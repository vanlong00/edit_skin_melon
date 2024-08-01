import 'dart:ui';

import 'package:edit_skin_melon/features/skin_editor/widgets/part_component.dart';
import 'package:image/image.dart' as img;

class ImageUtil {
  static bool hasPixel(int x, int y, img.Image imgImage) {
    img.Pixel pixel = imgImage.getPixelSafe(x, y);
    if (pixel.a == 0) {
      return false;
    } else {
      return true;
    }
  }

  static img.Image applyBrush(int localX, int localY, Color newColor, img.Image pix, int brushSize) {
    for (var i = 0; i < (brushSize + 1); i++) {
      for (var j = 0; j < (brushSize + 1); j++) {
        int y = (i + localY) - (brushSize ~/ 2);
        int x = (j + localX) - (brushSize ~/ 2);

        if (x < 0 || x >= pix.width || y < 0 || y >= pix.height) {
          continue;
        }
        setPixelSafe(x, y, pix, () => pix.setPixel(x, y, newColor.value.getColor()));
      }
    }

    return pix;
  }

  static void setPixelSafe(int x, int y, img.Image pix, Function setPixelFunc) {
    if (x < 0 || x >= pix.width || y < 0 || y >= pix.height) {
      return;
    }
    setPixelFunc.call();
  }
}
