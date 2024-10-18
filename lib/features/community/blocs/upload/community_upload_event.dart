part of 'community_upload_bloc.dart';

sealed class CommunityUploadEvent extends Equatable {
  const CommunityUploadEvent();
}

class CommunityUploadSelectFileEvent extends CommunityUploadEvent {
  const CommunityUploadSelectFileEvent();

  @override
  List<Object?> get props => [];
}

class CommunityUploadSelectImageOptionEvent extends CommunityUploadEvent {
  @override
  List<Object?> get props => [];
}

class CommunityUploadSelectThumbnailEvent extends CommunityUploadEvent {
  @override
  List<Object?> get props => [];
}
