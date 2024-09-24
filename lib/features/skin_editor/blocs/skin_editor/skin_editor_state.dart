part of 'skin_editor_bloc.dart';

class SkinEditorState extends Equatable {
  final ProjectItem? projectItem;
  final bool isLoading;
  final bool isDrawable;
  final Color colorDraw;
  final bool isShowGrid;
  final List<bool> isShowPart;

  const SkinEditorState({
    this.projectItem,
    this.isLoading = false,
    this.isDrawable = false,
    this.colorDraw = Colors.white,
    this.isShowGrid = false,
    this.isShowPart = const [],
  });

  SkinEditorState copyWith({
    ProjectItem? projectItem,
    bool? isLoading,
    bool? isDrawable,
    Color? colorDraw,
    bool? isShowGrid,
    List<bool>? isShowPart,
  }) {
    return SkinEditorState(
      projectItem: projectItem ?? this.projectItem,
      isLoading: isLoading ?? this.isLoading,
      isDrawable: isDrawable ?? this.isDrawable,
      colorDraw: colorDraw ?? this.colorDraw,
      isShowGrid: isShowGrid ?? this.isShowGrid,
      isShowPart: isShowPart ?? this.isShowPart,
    );
  }

  @override
  List<Object?> get props {
    return [
      projectItem,
      isLoading,
      isDrawable,
      colorDraw,
      isShowGrid,
      isShowPart,
    ];
  }
}
