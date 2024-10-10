import 'package:json_annotation/json_annotation.dart';

part 'melon.g.dart';

@JsonSerializable()
class Melon {
  final int id;
  final String name;
  final List<String>? images;
  final String author;
  final String description;
  final String? videoCode;
  final String fileUrl;
  final String thumbnailUrl;
  final String? modVersion;
  final int downloadCount;
  final DateTime uploadDate;
  final DateTime updatedDate;
  final DateTime? deletedAt;
  final int type;
  final bool isVerify;
  final bool isHide;
  final bool isCopyright;
  final int reportCount;
  final Category? category;
  final List<String>? tags;

  Melon({
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

  factory Melon.fromJson(Map<String, dynamic> json) => _$MelonFromJson(json);

  Map<String, dynamic> toJson() => _$MelonToJson(this);
}

@JsonSerializable()
class Category {
  final int id;
  final String name;

  Category({
    required this.id,
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}
