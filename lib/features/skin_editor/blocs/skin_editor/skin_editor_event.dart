part of 'skin_editor_bloc.dart';

sealed class SkinEditorEvent extends ReplayEvent with EquatableMixin {
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

class SkinEditorUpdateSkinEvent extends SkinEditorEvent {
  final String skinPath;
  final String dataPath;
  final int indexPart;

  const SkinEditorUpdateSkinEvent({required this.skinPath, required this.dataPath, required this.indexPart});

  @override
  List<Object?> get props => [skinPath, dataPath, indexPart];
}

class SkinEditorToPngEvent extends SkinEditorEvent {
  const SkinEditorToPngEvent();

  @override
  List<Object?> get props => [];
}
