import 'dart:convert';

import 'package:equatable/equatable.dart';

class ItemPos extends Equatable {
  final double? x;
  final double? y;

  const ItemPos({
    this.x,
    this.y,
  });

  ItemPos copyWith({
    double? x,
    double? y,
  }) =>
      ItemPos(
        x: x ?? this.x,
        y: y ?? this.y,
      );

  factory ItemPos.fromJson(String str) => ItemPos.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ItemPos.fromMap(Map<String, dynamic> json) => ItemPos(
        x: json["x"],
        y: json["y"],
      );

  Map<String, dynamic> toMap() => {
        "x": x,
        "y": y,
      };

  @override
  List<Object?> get props => [x, y];
}
