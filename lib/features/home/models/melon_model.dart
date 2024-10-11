import 'package:json_annotation/json_annotation.dart';

part 'melon_model.g.dart';

@JsonSerializable()
class MelonModel {
  final int? id;
  final String? name;
  final List<String>? images;
  final String? author;
  final String? description;
  final String? videoCode;
  final String? fileUrl;
  final String? thumbnailUrl;
  final String? modVersion;
  final int? downloadCount;
  final DateTime? uploadDate;
  final DateTime? updatedDate;
  final DateTime? deletedAt;
  final int? type;
  final bool? isVerify;
  final bool? isHide;
  final bool? isCopyright;
  final int? reportCount;
  final CategoryModel? category;
  final List<String>? tags;

  MelonModel({
    required this.id,
    required this.name,
    this.images,
    required this.author,
    required this.description,
    this.videoCode,
    required this.fileUrl,
    required this.thumbnailUrl,
    this.modVersion,
    required this.downloadCount,
    required this.uploadDate,
    required this.updatedDate,
    this.deletedAt,
    required this.type,
    required this.isVerify,
    required this.isHide,
    required this.isCopyright,
    required this.reportCount,
    this.category,
    required this.tags,
  });

  factory MelonModel.fromJson(Map<String, dynamic> json) => _$MelonModelFromJson(json);

  Map<String, dynamic> toJson() => _$MelonModelToJson(this);
}

@JsonSerializable()
class CategoryModel {
  final int id;
  final String name;

  CategoryModel({
    required this.id,
    required this.name,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);
}
