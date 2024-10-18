part of 'community_upload_bloc.dart';

class CommunityUploadState extends Equatable {
  final XFile? fileUpload;
  final List<XFile>? imagesOption;
  final XFile? imageThumbnail;

  const CommunityUploadState({
    this.fileUpload,
    this.imagesOption,
    this.imageThumbnail,
  });

  CommunityUploadState copyWith({
    XFile? fileUpload,
    List<XFile>? imagesOption,
    XFile? imageThumbnail,
  }) {
    return CommunityUploadState(
      fileUpload: fileUpload ?? this.fileUpload,
      imagesOption: imagesOption ?? this.imagesOption,
      imageThumbnail: imageThumbnail ?? this.imageThumbnail,
    );
  }

  @override
  List<Object?> get props {
    return [
      fileUpload,
      imagesOption,
      imageThumbnail,
    ];
  }
}
