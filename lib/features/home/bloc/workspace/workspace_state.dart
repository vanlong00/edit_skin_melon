part of 'workspace_bloc.dart';

class WorkspaceState extends Equatable {
  final List<WorkspaceModel> items;

  const WorkspaceState({required this.items});

  factory WorkspaceState.empty() => const WorkspaceState(items: []);

  @override
  // TODO: implement props
  List<Object?> get props => [items];
}
