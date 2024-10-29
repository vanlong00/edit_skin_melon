import 'dart:typed_data';

import 'package:edit_skin_melon/core/converter/uint8list_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'workspace_model.g.dart';

@JsonSerializable()
class WorkspaceModel {
  final String? name;
  @Uint8ListConverter()
  final Uint8List? image;
  final String? locatedAt;

  WorkspaceModel({
    this.name,
    this.image,
    this.locatedAt,
  });

  factory WorkspaceModel.fromJson(Map<String, dynamic> json) => _$WorkspaceModelFromJson(json);

  Map<String, dynamic> toJson() => _$WorkspaceModelToJson(this);
}
