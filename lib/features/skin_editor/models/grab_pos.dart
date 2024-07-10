import 'dart:convert';

import 'package:equatable/equatable.dart';

class GrabPos extends Equatable {
  final double? x;
  final double? y;
  final double? z;

  const GrabPos({
    this.x,
    this.y,
    this.z,
  });

  factory GrabPos.fromJson(String str) => GrabPos.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GrabPos.fromMap(Map<String, dynamic> json) => GrabPos(
        x: json["x"],
        y: json["y"],
        z: json["z"],
      );

  Map<String, dynamic> toMap() => {
        "x": x,
        "y": y,
        "z": z,
      };

  GrabPos copyWith({
    double? x,
    double? y,
    double? z,
  }) =>
      GrabPos(
        x: x ?? this.x,
        y: y ?? this.y,
        z: z ?? this.z,
      );

  @override
  List<Object?> get props => [x, y, z];
}
