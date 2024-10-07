part of 'skin_editor_bloc.dart';

class SkinEditorState extends Equatable {
  final ProjectItem? projectItem;
  final bool isLoading;
  final bool isDrawable;
  final Color colorDraw;
  final bool isShowGrid;
  final bool isShowSelectionPart;
  final List<bool> isShowPart;

  const SkinEditorState({
    this.projectItem,
    this.isLoading = false,
    this.isDrawable = false,
    this.colorDraw = Colors.white,
    this.isShowGrid = false,
    this.isShowSelectionPart = false,
    this.isShowPart = const [],
  });

  SkinEditorState copyWith({
    ProjectItem? projectItem,
    bool? isLoading,
    bool? isDrawable,
    Color? colorDraw,
    bool? isShowGrid,
    bool? isShowSelectionPart,
    List<bool>? isShowPart,
  }) {
    return SkinEditorState(
      projectItem: projectItem ?? this.projectItem,
      isLoading: isLoading ?? this.isLoading,
      isDrawable: isDrawable ?? this.isDrawable,
      colorDraw: colorDraw ?? this.colorDraw,
      isShowGrid: isShowGrid ?? this.isShowGrid,
      isShowPart: isShowPart ?? this.isShowPart,
      isShowSelectionPart: isShowSelectionPart ?? this.isShowSelectionPart,
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
      isShowSelectionPart,
    ];
  }
}
