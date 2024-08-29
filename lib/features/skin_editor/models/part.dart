import 'dart:convert';
import 'dart:typed_data';

import 'package:edit_skin_melon/core/utils/helpers/base_x_codec_helper.dart';
import 'package:edit_skin_melon/features/skin_editor/models/grab_pos.dart';
import 'package:equatable/equatable.dart';

class Part extends Equatable {
  final String? mainTexture;
  final Uint8List? mainTextureUint8List;
  final double? pixelsPerUnit;
  final int? mainTextureWidth;
  final int? mainTextureHeight;
  final List<dynamic>? collidersJson;
  final List<String>? glowMap;
  final GrabPos? grabPosition;
  final bool? canBeTaken;
  final bool? canGlow;
  final bool? canBurn;
  final bool? canFloat;

  const Part({
    this.mainTexture,
    this.mainTextureUint8List,
    this.pixelsPerUnit,
    this.mainTextureWidth,
    this.mainTextureHeight,
    this.collidersJson,
    this.glowMap,
    this.grabPosition,
    this.canBeTaken,
    this.canGlow,
    this.canBurn,
    this.canFloat,
  });

  Part copyWith({
    String? mainTexture,
    Uint8List? mainTextureUint8List,
    double? pixelsPerUnit,
    int? mainTextureWidth,
    int? mainTextureHeight,
    List<String>? collidersJson,
    List<String>? glowMap,
    GrabPos? grabPosition,
    bool? canBeTaken,
    bool? canGlow,
    bool? canBurn,
    bool? canFloat,
  }) =>
      Part(
        mainTexture: mainTexture ?? this.mainTexture,
        mainTextureUint8List: mainTextureUint8List ?? this.mainTextureUint8List,
        pixelsPerUnit: pixelsPerUnit ?? this.pixelsPerUnit,
        mainTextureWidth: mainTextureWidth ?? this.mainTextureWidth,
        mainTextureHeight: mainTextureHeight ?? this.mainTextureHeight,
        collidersJson: collidersJson ?? this.collidersJson,
        glowMap: glowMap ?? this.glowMap,
        grabPosition: grabPosition ?? this.grabPosition,
        canBeTaken: canBeTaken ?? this.canBeTaken,
        canGlow: canGlow ?? this.canGlow,
        canBurn: canBurn ?? this.canBurn,
        canFloat: canFloat ?? this.canFloat,
      );

  factory Part.fromJson(String str) => Part.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  String toJson2() => json.encode(toMap2());

  factory Part.fromMap(Map<String, dynamic> json) {
    final mainTextureUint8List = json["mainTexture"] != null ? BaseXCodecHelper().decode(json["mainTexture"]) : null;

    return Part(
      mainTexture: json["mainTexture"],
      mainTextureUint8List: json["mainTextureUint8List"] ?? mainTextureUint8List,
      pixelsPerUnit: json["pixelsPerUnit"],
      mainTextureWidth: json["mainTextureWidth"],
      mainTextureHeight: json["mainTextureHeight"],
      collidersJson: List<String>.from(json["collidersJson"].map((x) => x)),
      glowMap: List<String>.from(json["glowMap"].map((x) => x)),
      grabPosition: GrabPos.fromMap(json["grabPosition"]),
      canBeTaken: json["canBeTaken"],
      canGlow: json["canGlow"],
      canBurn: json["canBurn"],
      canFloat: json["canFloat"],
    );
  }

  Map<String, dynamic> toMap() => {
        "mainTexture": mainTexture,
        "pixelsPerUnit": pixelsPerUnit,
        "mainTextureWidth": mainTextureWidth,
        "mainTextureHeight": mainTextureHeight,
        "collidersJson": collidersJson != null ? List<dynamic>.from(collidersJson!.map((x) => x)) : [],
        "glowMap": glowMap != null ? List<dynamic>.from(glowMap!.map((x) => x)) : [],
        "grabPosition": grabPosition?.toMap(),
        "canBeTaken": canBeTaken,
        "canGlow": canGlow,
        "canBurn": canBurn,
        "canFloat": canFloat,
      };

  Map<String, dynamic> toMap2() => {
        "pixelsPerUnit": pixelsPerUnit,
        "collidersJson": collidersJson != null ? List<dynamic>.from(collidersJson!.map((x) => x)) : [],
        "glowMap": glowMap != null ? List<dynamic>.from(glowMap!.map((x) => x)) : [],
        "grabPosition": grabPosition?.toMap(),
        "canBeTaken": canBeTaken,
        "canGlow": canGlow,
        "canBurn": canBurn,
        "canFloat": canFloat,
      };

  @override
  List<Object?> get props => [
        mainTexture,
        mainTextureUint8List,
        pixelsPerUnit,
        mainTextureWidth,
        mainTextureHeight,
        collidersJson,
        glowMap,
        grabPosition,
        canBeTaken,
        canGlow,
        canBurn,
        canFloat,
      ];
}
