import 'dart:convert';

import 'package:equatable/equatable.dart';

class MetaData extends Equatable {
  final String? manifestId;
  final String? name;

  const MetaData({
    this.manifestId,
    this.name,
  });

  MetaData copyWith({
    String? manifestId,
    String? name,
  }) =>
      MetaData(
        manifestId: manifestId ?? this.manifestId,
        name: name ?? this.name,
      );

  factory MetaData.fromJson(String str) => MetaData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MetaData.fromMap(Map<String, dynamic> json) => MetaData(
        manifestId: json["ManifestId"],
        name: json["Name"],
      );

  Map<String, dynamic> toMap() => {
        "ManifestId": manifestId,
        "Name": name,
      };

  @override
  List<Object?> get props => [manifestId, name];
}
