// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workspace_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkspaceModel _$WorkspaceModelFromJson(Map<String, dynamic> json) =>
    WorkspaceModel(
      json['name'] as String?,
      const Uint8ListConverter().fromJson(json['image'] as String?),
      json['locatedAt'] as String?,
    );

Map<String, dynamic> _$WorkspaceModelToJson(WorkspaceModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'image': const Uint8ListConverter().toJson(instance.image),
      'locatedAt': instance.locatedAt,
    };
