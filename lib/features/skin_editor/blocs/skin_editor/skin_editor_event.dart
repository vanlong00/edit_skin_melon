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

class SkinEditorUpdatePartEvent extends SkinEditorEvent {
  final String skinPath;
  final String dataPath;
  final int indexPart;

  const SkinEditorUpdatePartEvent({required this.skinPath, required this.dataPath, required this.indexPart});

  @override
  List<Object?> get props => [skinPath, dataPath, indexPart];
}

class SkinEditorBlendColorEvent extends SkinEditorEvent {
  final Uint8List data;
  final int indexPart;

  const SkinEditorBlendColorEvent(this.indexPart, {required this.data});

  @override
  List<Object?> get props => [data];
}

class SkinEditorToPngEvent extends SkinEditorEvent {
  const SkinEditorToPngEvent();

  @override
  List<Object?> get props => [];
}
