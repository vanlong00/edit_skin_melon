import 'dart:typed_data';

import 'package:base_x/base_x.dart';

class BaseXCodecHelper {
  final BaseXCodec base;

  BaseXCodecHelper() : base = BaseXCodec('ABCDEFGHIJKLMNOP');

  String encode(Uint8List data) => base.encoder.convert(data);

  Uint8List decode(String data) => base.decoder.convert(data);
}
