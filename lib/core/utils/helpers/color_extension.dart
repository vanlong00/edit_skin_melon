import 'package:image/image.dart' as img;

extension ColorExtension on int {
  int getRed() => this & 0xff;

  int getGreen() => (this >> 8) & 0xff;

  int getBlue() => (this >> 16) & 0xff;

  int getAlpha() => (this >> 24) & 0xff;

  img.Color getColor() => img.ColorUint32.rgba(getBlue(), getGreen(), getRed(), getAlpha());
}
