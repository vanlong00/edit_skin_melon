part of 'skin_editor_bloc.dart';

sealed class SkinEditorEvent extends Equatable {
  const SkinEditorEvent();
}

class SkinEditorInitialEvent extends SkinEditorEvent {
  final String pathDefault;

  const SkinEditorInitialEvent(this.pathDefault);

  @override
  List<Object?> get props => [pathDefault];
}

class SkinEditorChangeSkinEvent extends SkinEditorEvent {
  final Uint8List skin;

  const SkinEditorChangeSkinEvent(this.skin);

  @override
  List<Object?> get props => [skin];
}

class SkinEditorToPngEvent extends SkinEditorEvent {
  const SkinEditorToPngEvent();

  @override
  List<Object?> get props => [];
}