part of 'skin_editor_bloc.dart';

class SkinEditorState extends Equatable {
  const SkinEditorState({this.projectItem, this.isLoading = false});

  const SkinEditorState.initial()
      : projectItem = null,
        isLoading = false;

  const SkinEditorState.error({this.projectItem, this.isLoading = false, String? error});

  final ProjectItem? projectItem;
  final bool isLoading;

  SkinEditorState copyWith({
    ProjectItem? projectItem,
    bool? isLoading,
  }) {
    return SkinEditorState(
      projectItem: projectItem ?? this.projectItem,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props {

    return [
      projectItem,
      isLoading,
    ];
  }
}
