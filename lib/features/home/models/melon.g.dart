// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'melon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Melon _$MelonFromJson(Map<String, dynamic> json) => Melon(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      images:
          (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
      author: json['author'] as String,
      description: json['description'] as String,
      videoCode: json['videoCode'] as String,
      fileUrl: json['fileUrl'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      modVersion: json['modVersion'] as String?,
      downloadCount: (json['downloadCount'] as num).toInt(),
      uploadDate: DateTime.parse(json['uploadDate'] as String),
      updatedDate: DateTime.parse(json['updatedDate'] as String),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
      type: (json['type'] as num).toInt(),
      isVerify: json['isVerify'] as bool,
      isHide: json['isHide'] as bool,
      isCopyright: json['isCopyright'] as bool,
      reportCount: (json['reportCount'] as num).toInt(),
      category: json['category'] == null
          ? null
          : Category.fromJson(json['category'] as Map<String, dynamic>),
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$MelonToJson(Melon instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'images': instance.images,
      'author': instance.author,
      'description': instance.description,
      'videoCode': instance.videoCode,
      'fileUrl': instance.fileUrl,
      'thumbnailUrl': instance.thumbnailUrl,
      'modVersion': instance.modVersion,
      'downloadCount': instance.downloadCount,
      'uploadDate': instance.uploadDate.toIso8601String(),
      'updatedDate': instance.updatedDate.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'type': instance.type,
      'isVerify': instance.isVerify,
      'isHide': instance.isHide,
      'isCopyright': instance.isCopyright,
      'reportCount': instance.reportCount,
      'category': instance.category,
      'tags': instance.tags,
    };

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
