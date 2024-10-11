part of 'skin_editor_bloc.dart';

enum SkinEditorStatusState {
  initial,
  loading,
  complete,
  error,
}

class SkinEditorState extends Equatable {
  final ProjectItem? projectItem;
  final bool isDrawable;
  final Color colorDraw;
  final bool isShowGrid;
  final bool isShowSelectionPart;
  final List<bool> isShowPart;
  final SkinEditorStatusState status;

  const SkinEditorState({
    this.projectItem,
    this.isDrawable = false,
    this.colorDraw = Colors.white,
    this.isShowGrid = false,
    this.isShowSelectionPart = false,
    this.isShowPart = const [],
    this.status = SkinEditorStatusState.loading,
  });

  SkinEditorState copyWith({
    ProjectItem? projectItem,
    bool? isLoading,
    bool? isDrawable,
    Color? colorDraw,
    bool? isShowGrid,
    bool? isShowSelectionPart,
    List<bool>? isShowPart,
    SkinEditorStatusState? status,
  }) {
    return SkinEditorState(
      projectItem: projectItem ?? this.projectItem,
      isDrawable: isDrawable ?? this.isDrawable,
      colorDraw: colorDraw ?? this.colorDraw,
      isShowGrid: isShowGrid ?? this.isShowGrid,
      isShowPart: isShowPart ?? this.isShowPart,
      isShowSelectionPart: isShowSelectionPart ?? this.isShowSelectionPart,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props {
    return [
      projectItem,
      isDrawable,
      colorDraw,
      isShowGrid,
      isShowPart,
      isShowSelectionPart,
      status,
    ];
  }
}
