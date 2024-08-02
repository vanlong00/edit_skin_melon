import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'meta_data.dart';
import 'mod_human.dart';
import 'part.dart';

class ProjectItem extends Equatable {
  final int? convertVersion;
  final int? modType;
  final String? uniqueId;
  final String? type;
  final String? category;
  final String? customCategory;
  final bool? isActivated;
  final List<int>? icon;
  final int? iconWidth;
  final int? iconHeight;
  final List<Part>? parts;
  final List<ModHuman>? modHuman;
  final List<dynamic>? modFirearms;
  final MetaData? metadata;
  final List<dynamic>? colorData;
  final List<dynamic>? scriptsData;

  const ProjectItem({
    this.convertVersion,
    this.modType,
    this.uniqueId,
    this.type,
    this.category,
    this.customCategory,
    this.isActivated,
    this.icon,
    this.iconWidth,
    this.iconHeight,
    this.parts,
    this.modHuman,
    this.modFirearms,
    this.metadata,
    this.colorData,
    this.scriptsData,
  });

  ProjectItem copyWith({
    int? convertVersion,
    int? modType,
    String? uniqueId,
    String? type,
    String? category,
    String? customCategory,
    bool? isActivated,
    List<int>? icon,
    int? iconWidth,
    int? iconHeight,
    List<Part>? parts,
    List<ModHuman>? modHuman,
    List<dynamic>? modFirearms,
    MetaData? metadata,
    List<dynamic>? colorData,
    List<dynamic>? scriptsData,
  }) =>
      ProjectItem(
        convertVersion: convertVersion ?? this.convertVersion,
        modType: modType ?? this.modType,
        uniqueId: uniqueId ?? this.uniqueId,
        type: type ?? this.type,
        category: category ?? this.category,
        customCategory: customCategory ?? this.customCategory,
        isActivated: isActivated ?? this.isActivated,
        icon: icon ?? this.icon,
        iconWidth: iconWidth ?? this.iconWidth,
        iconHeight: iconHeight ?? this.iconHeight,
        parts: parts ?? this.parts,
        modHuman: modHuman ?? this.modHuman,
        modFirearms: modFirearms ?? this.modFirearms,
        metadata: metadata ?? this.metadata,
        colorData: colorData ?? this.colorData,
        scriptsData: scriptsData ?? this.scriptsData,
      );

  factory ProjectItem.fromJson(String str) => ProjectItem.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProjectItem.fromMap(Map<String, dynamic> json) => ProjectItem(
        convertVersion: json["convertVersion"],
        modType: json["modType"],
        uniqueId: json["uniqueId"],
        type: json["type"],
        category: json["category"],
        customCategory: json["customCategory"],
        isActivated: json["isActivated"],
        icon: List<int>.from(json["icon"].map((x) => x)),
        iconWidth: json["iconWidth"],
        iconHeight: json["iconHeight"],
        parts: List<Part>.from(json["parts"].map((x) => Part.fromMap(x))),
        modHuman: List<ModHuman>.from(json["modHuman"].map((x) => ModHuman.fromMap(x))),
        modFirearms: List<dynamic>.from(json["modFirearms"].map((x) => x)),
        metadata: MetaData.fromMap(json["metadata"]),
        colorData: json["colorData"] != null ? List<dynamic>.from(json["colorData"].map((x) => x)) : null,
        scriptsData: json["ScriptsData"] != null ? List<dynamic>.from(json["ScriptsData"].map((x) => x)) : null,
      );

  Map<String, dynamic> toMap() => {
        "convertVersion": convertVersion,
        "modType": modType,
        "uniqueId": uniqueId,
        "type": type,
        "category": category,
        "customCategory": customCategory,
        "isActivated": isActivated,
        "icon": icon != null ? List<dynamic>.from(icon!.map((x) => x)) : [],
        "iconWidth": iconWidth,
        "iconHeight": iconHeight,
        "parts": parts != null ? List<dynamic>.from(parts!.map((x) => x.toMap())) : [],
        "modHuman": modHuman != null ? List<dynamic>.from(modHuman!.map((x) => x.toMap())) : [],
        "modFirearms": [],
        "metadata": metadata?.toMap(),
        "colorData": [],
        "ScriptsData": [],
      };

  @override
  List<Object?> get props => [
        convertVersion,
        modType,
        uniqueId,
        type,
        category,
        customCategory,
        isActivated,
        icon,
        iconWidth,
        iconHeight,
        parts,
        modHuman,
        modFirearms,
        metadata,
        colorData,
        scriptsData,
      ];
}
