part of 'community_upload_bloc.dart';

sealed class CommunityUploadEvent extends Equatable {
  const CommunityUploadEvent();
}

class CommunityUploadInitEvent extends CommunityUploadEvent {
  final WorkspaceModel? item;

  const CommunityUploadInitEvent(this.item);

  @override
  List<Object?> get props => [item];
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

class CommunityUploadSubmitEvent extends CommunityUploadEvent {
  final String name;
  final String author;
  final String description;

  const CommunityUploadSubmitEvent({required this.name, required this.author, required this.description});

  @override
  List<Object?> get props => [
    name,
    author,
    description,
  ];
}