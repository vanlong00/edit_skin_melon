part of 'workspace_bloc.dart';

sealed class WorkspaceEvent extends Equatable {
  const WorkspaceEvent();
}

class AddWorkspaceEvent extends WorkspaceEvent {
  final WorkspaceModel workspace;

  const AddWorkspaceEvent(this.workspace);

  @override
  List<Object?> get props => [workspace];
}

class RemoveWorkspaceEvent extends WorkspaceEvent {
  final WorkspaceModel workspace;

  const RemoveWorkspaceEvent(this.workspace);

  @override
  List<Object?> get props => [workspace];
}