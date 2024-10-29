part of 'community_upload_bloc.dart';

enum CommunityUploadStatus {
  init,
  submit,
  submitSuccess,
  submitFailed,
}

class CommunityUploadState extends Equatable {
  final XFile? fileUpload;
  final List<XFile>? imagesOption;
  final Uint8List? imageThumbnail;
  final CommunityUploadStatus status;
  final String? errorMessage;

  const CommunityUploadState({
    this.fileUpload,
    this.imagesOption,
    this.imageThumbnail,
    this.errorMessage,
    this.status = CommunityUploadStatus.init,
  });

  CommunityUploadState copyWith({
    XFile? fileUpload,
    List<XFile>? imagesOption,
    Uint8List? imageThumbnail,
    String? errorMessage,
    CommunityUploadStatus? status,
  }) {
    return CommunityUploadState(
      fileUpload: fileUpload ?? this.fileUpload,
      imagesOption: imagesOption ?? this.imagesOption,
      imageThumbnail: imageThumbnail ?? this.imageThumbnail,
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props {
    return [
      fileUpload,
      imagesOption,
      imageThumbnail,
      status,
      errorMessage,
    ];
  }
}
