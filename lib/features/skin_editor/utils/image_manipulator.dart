import 'dart:ui';

import 'package:edit_skin_melon/core/utils/helpers/color_extension.dart';
import 'package:image/image.dart' as img;

/// A utility class for image manipulation.
class ImageManipulator {
  /// Checks if a pixel at the given coordinates (x, y) in the provided image has any color.
  ///
  /// @param x The x-coordinate of the pixel.
  /// @param y The y-coordinate of the pixel.
  /// @param imgImage The image to check the pixel in.
  /// @return True if the pixel has color, false if it is transparent.
  static bool hasPixel(int x, int y, img.Image imgImage) {
    img.Pixel pixel = imgImage.getPixelSafe(x, y);
    if (pixel.a == 0) {
      return false;
    } else {
      return true;
    }
  }

  /// Applies a brush stroke of the specified color and size to the image at the given coordinates.
  ///
  /// @param localX The x-coordinate where the brush is applied.
  /// @param localY The y-coordinate where the brush is applied.
  /// @param newColor The color to apply with the brush.
  /// @param pix The image to apply the brush to.
  /// @param brushSize The size of the brush.
  /// @return The modified image.
  static img.Image applyBrush(int localX, int localY, Color newColor, img.Image pix, int brushSize) {
    for (var i = 0; i <= brushSize; i++) {
      for (var j = 0; j <= brushSize; j++) {
        int y = localY + i;
        int x = localX + j;

        if (x < 0 || x >= pix.width || y < 0 || y >= pix.height) {
          continue;
        }
        setPixelSafe(x, y, pix, () => pix.setPixel(x, y, newColor.value.getColor()));
      }
    }

    return pix;
  }

  /// Sets a pixel in the image at the given coordinates if they are within the image bounds.
  ///
  /// @param x The x-coordinate of the pixel.
  /// @param y The y-coordinate of the pixel.
  /// @param pix The image to set the pixel in.
  /// @param setPixelFunc The function to set the pixel.
  static void setPixelSafe(int x, int y, img.Image pix, Function setPixelFunc) {
    if (x < 0 || x >= pix.width || y < 0 || y >= pix.height) {
      return;
    }

    if (pix.getPixelSafe(x, y).a == 0) {
      return;
    }

    setPixelFunc.call();
  }
}