import 'dart:convert';
import 'dart:typed_data';
import 'package:json_annotation/json_annotation.dart';

class Uint8ListConverter implements JsonConverter<Uint8List?, String?> {
  const Uint8ListConverter();

  @override
  Uint8List? fromJson(String? json) {
    return json != null ? base64Decode(json) : null;
  }

  @override
  String? toJson(Uint8List? object) {
    return object != null ? base64Encode(object) : null;
  }
}