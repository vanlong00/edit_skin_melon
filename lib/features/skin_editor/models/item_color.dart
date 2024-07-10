import 'dart:convert';

import 'package:equatable/equatable.dart';

class ItemColor extends Equatable {
  final double? r;
  final double? g;
  final double? b;
  final double? a;

  const ItemColor({
    this.r,
    this.g,
    this.b,
    this.a,
  });

  ItemColor copyWith({
    double? r,
    double? g,
    double? b,
    double? a,
  }) =>
      ItemColor(
        r: r ?? this.r,
        g: g ?? this.g,
        b: b ?? this.b,
        a: a ?? this.a,
      );

  factory ItemColor.fromJson(String str) => ItemColor.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ItemColor.fromMap(Map<String, dynamic> json) => ItemColor(
    r: json["r"].toDouble(),
    g: json["g"].toDouble(),
    b: json["b"].toDouble(),
    a: json["a"],
  );

  Map<String, dynamic> toMap() => {
    "r": r,
    "g": g,
    "b": b,
    "a": a,
  };

  @override
  List<Object?> get props => [
    r,
    g,
    b,
    a,
  ];
}