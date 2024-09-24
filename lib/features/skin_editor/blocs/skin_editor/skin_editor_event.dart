part of 'skin_editor_bloc.dart';

sealed class SkinEditorEvent extends ReplayEvent with EquatableMixin {
  const SkinEditorEvent();
}

class SkinEditorInitialEvent extends SkinEditorEvent {
  final String pathDefault;
  final BuildContext context;

  const SkinEditorInitialEvent(this.pathDefault, {required this.context});

  @override
  List<Object?> get props => [pathDefault, context];
}

class SkinEditorUpdateAvailableModelEvent extends SkinEditorEvent {
  final String skinPath;
  final String dataPath;
  final int indexPart;

  const SkinEditorUpdateAvailableModelEvent({required this.skinPath, required this.dataPath, required this.indexPart});

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

class SkinEditorIsShowPartEvent extends SkinEditorEvent {
  final List<int> indexPart;

  const SkinEditorIsShowPartEvent(this.indexPart);

  @override
  List<Object?> get props => [indexPart];
}
/// ---------------------
/// From this, we use to update state not relate to ProjectItem

class SkinEditorSwitchIsDrawableEvent extends SkinEditorEvent {
  const SkinEditorSwitchIsDrawableEvent();

  @override
  List<Object?> get props => [];
}

class SkinEditorPickColorEvent extends SkinEditorEvent {
  final Color color;

  const SkinEditorPickColorEvent(this.color);

  @override
  List<Object?> get props => [color];
}

class SkinEditorSwitchIsShowGridEvent extends SkinEditorEvent {
  const SkinEditorSwitchIsShowGridEvent();

  @override
  List<Object?> get props => [];
}

class SkinEditorSwitchIsShowPartEvent extends SkinEditorEvent {
  final List<int> indexPart;

  const SkinEditorSwitchIsShowPartEvent(this.indexPart);

  @override
  List<Object?> get props => [indexPart];
}


