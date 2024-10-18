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
  final Uint8List? imageScreenshot;

  const SkinEditorState({
    this.projectItem,
    this.isDrawable = false,
    this.colorDraw = Colors.white,
    this.isShowGrid = false,
    this.isShowSelectionPart = false,
    this.isShowPart = const [],
    this.status = SkinEditorStatusState.loading,
    this.imageScreenshot,
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
    Uint8List? imageScreenshot,
  }) {
    return SkinEditorState(
      projectItem: projectItem ?? this.projectItem,
      isDrawable: isDrawable ?? this.isDrawable,
      colorDraw: colorDraw ?? this.colorDraw,
      isShowGrid: isShowGrid ?? this.isShowGrid,
      isShowPart: isShowPart ?? this.isShowPart,
      isShowSelectionPart: isShowSelectionPart ?? this.isShowSelectionPart,
      status: status ?? this.status,
      imageScreenshot: imageScreenshot ?? this.imageScreenshot,
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
      imageScreenshot,
    ];
  }
}
