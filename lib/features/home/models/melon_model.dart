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
    this.id,
    this.name,
    this.images,
    this.author,
    this.description,
    this.videoCode,
    this.fileUrl,
    this.thumbnailUrl,
    this.modVersion,
    this.downloadCount,
    this.uploadDate,
    this.updatedDate,
    this.deletedAt,
    this.type,
    this.isVerify,
    this.isHide,
    this.isCopyright,
    this.reportCount,
    this.category,
    this.tags,
  });

  factory MelonModel.fromJson(Map<String, dynamic> json) => _$MelonModelFromJson(json);

  Map<String, dynamic> toJson() => _$MelonModelToJson(this);
}

@JsonSerializable()
class CategoryModel {
  final int? id;
  final String? name;

  CategoryModel({
    this.id,
    this.name,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);
}
