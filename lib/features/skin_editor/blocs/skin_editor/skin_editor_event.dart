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

class SkinEditorIsShowPartEvent extends SkinEditorEvent {
  final List<int> indexPart;

  const SkinEditorIsShowPartEvent(this.indexPart);

  @override
  List<Object?> get props => [indexPart];
}

class SkinEditorUpdatePartEvent extends SkinEditorEvent {
  final List<Part> parts;

  const SkinEditorUpdatePartEvent(this.parts);

  @override
  List<Object?> get props => [parts];
}

class SkinEditorUpdateCategoryEvent extends SkinEditorEvent {
  final String category;

  const SkinEditorUpdateCategoryEvent(this.category);

  @override
  List<Object?> get props => [category];
}

class SkinEditorSwitchAllPartsPropertiesEvent extends SkinEditorEvent {
  final bool value;
  final String property;

  const SkinEditorSwitchAllPartsPropertiesEvent({
    required this.value,
    required this.property,
  });

  @override
  List<Object?> get props => [
        value,
        property,
      ];
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
