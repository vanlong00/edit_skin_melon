part of 'skin_editor_bloc.dart';

class SkinEditorState extends Equatable {
  final ProjectItem? projectItem;
  final bool isLoading;
  final bool isDrawable;
  final Color colorDraw;

  const SkinEditorState({
    this.projectItem,
    this.isLoading = false,
    this.isDrawable = false,
    this.colorDraw = Colors.red,
  });

  SkinEditorState copyWith({
    ProjectItem? projectItem,
    bool? isLoading,
    bool? isDrawable,
    Color? colorDraw,
  }) {
    return SkinEditorState(
      projectItem: projectItem ?? this.projectItem,
      isLoading: isLoading ?? this.isLoading,
      isDrawable: isDrawable ?? this.isDrawable,
      colorDraw: colorDraw ?? this.colorDraw,
    );
  }

  @override
  List<Object?> get props {
    return [
      projectItem,
      isLoading,
      isDrawable,
      colorDraw,
    ];
  }
}
