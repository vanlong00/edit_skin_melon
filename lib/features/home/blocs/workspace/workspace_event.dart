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

class AddMelonEvent extends WorkspaceEvent {
  final MelonModel melon;

  const AddMelonEvent(this.melon);

  @override
  List<Object?> get props => [melon];
}

class RemoveMelonEvent extends WorkspaceEvent {
  final MelonModel melon;

  const RemoveMelonEvent(this.melon);

  @override
  List<Object?> get props => [melon];
}