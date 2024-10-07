import 'dart:convert';

import 'package:edit_skin_melon/features/skin_editor/models/item_pos.dart';
import 'package:equatable/equatable.dart';

import 'item_color.dart';

class ModHuman extends Equatable {
  final bool? canBlink;
  final ItemColor? eyeLid;
  final ItemColor? bloodColor;
  final List<dynamic>? eyePos;
  final List<String>? secondTextures;
  final List<String>? thirdTextures;

  const ModHuman({
    this.canBlink,
    this.eyeLid,
    this.bloodColor,
    this.eyePos,
    this.secondTextures,
    this.thirdTextures,
  });

  ModHuman copyWith({
    bool? canBlink,
    ItemColor? eyeLid,
    ItemColor? bloodColor,
    List<ItemPos>? eyePos,
    List<String>? secondTextures,
    List<String>? thirdTextures,
  }) =>
      ModHuman(
        canBlink: canBlink ?? this.canBlink,
        eyeLid: eyeLid ?? this.eyeLid,
        bloodColor: bloodColor ?? this.bloodColor,
        eyePos: eyePos ?? this.eyePos,
        secondTextures: secondTextures ?? this.secondTextures,
        thirdTextures: thirdTextures ?? this.thirdTextures,
      );

  factory ModHuman.fromJson(String str) => ModHuman.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ModHuman.fromMap(Map<String, dynamic> json) => ModHuman(
        canBlink: json["canBlink"],
        eyeLid: ItemColor.fromMap(json["eyeLid"]),
        bloodColor: ItemColor.fromMap(json["bloodColor"]),
        eyePos: json["eyePos"] != null ? List<ItemPos>.from(json["eyePos"].map((x) => ItemPos.fromMap(x))) : null,
        secondTextures: List<String>.from(json["secondTextures"].map((x) => x)),
        thirdTextures: List<String>.from(json["thirdTextures"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "canBlink": canBlink,
        "eyeLid": eyeLid != null ? eyeLid?.toMap() : {},
        "bloodColor": bloodColor?.toMap(),
        "eyePos": eyePos != null ? List<dynamic>.from(eyePos!.map((x) => x.toMap())) : [],
        "secondTextures": secondTextures != null ? List<dynamic>.from(secondTextures!.map((x) => x)) : [],
        "thirdTextures": thirdTextures != null ? List<dynamic>.from(thirdTextures!.map((x) => x)) : [],
      };

  @override
  List<Object?> get props => [
        canBlink,
        eyeLid,
        bloodColor,
        eyePos,
        secondTextures,
        thirdTextures,
      ];
}
