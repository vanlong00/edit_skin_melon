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
