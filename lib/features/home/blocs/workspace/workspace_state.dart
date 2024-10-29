part of 'workspace_bloc.dart';

class WorkspaceState extends Equatable {
  final List<WorkspaceModel> workSpaceItems;
  final List<MelonModel> melonItems;

  const WorkspaceState({required this.workSpaceItems, this.melonItems = const []});

  factory WorkspaceState.empty() => const WorkspaceState(workSpaceItems: [], melonItems: []);

  WorkspaceState copyWith({
    List<WorkspaceModel>? workSpaceItems,
    List<MelonModel>? melonItems,
  }) {
    return WorkspaceState(
      workSpaceItems: workSpaceItems ?? this.workSpaceItems,
      melonItems: melonItems ?? this.melonItems,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [workSpaceItems, melonItems];
}
