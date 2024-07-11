import 'dart:typed_data';

import 'package:base_x/base_x.dart';

class BaseXCodecUtil {
  final BaseXCodec base;

  BaseXCodecUtil() : base = BaseXCodec('ABCDEFGHIJKLMNOP');

  String encode(Uint8List data) {
    return base.encoder.convert(data);
  }

  Uint8List decode(String data) {
    return base.decoder.convert(data);
  }
}