import 'dart:async';
import 'dart:io';

import 'package:edit_skin_melon/features/home/models/workspace_model.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';

part 'workspace_event.dart';
part 'workspace_state.dart';

@lazySingleton
class WorkspaceBloc extends HydratedBloc<WorkspaceEvent, WorkspaceState> {
  WorkspaceBloc() : super(WorkspaceState.empty()) {
    on<AddWorkspaceEvent>(_onAddWorkspace);
    on<RemoveWorkspaceEvent>(_onRemoveWorkspace);
  }

  @override
  WorkspaceState? fromJson(Map<String, dynamic> json) {
    return WorkspaceState(
      items: (json['items'] as List<dynamic>).map((e) => WorkspaceModel.fromJson(e)).toList(),
    );
  }

  @override
  Map<String, dynamic>? toJson(WorkspaceState state) {
    return {
      'items': state.items.map((e) => e.toJson()).toList(),
    };
  }

  FutureOr<void> _onAddWorkspace(AddWorkspaceEvent event, Emitter<WorkspaceState> emit) {
    final updatedItems = List<WorkspaceModel>.from(state.items)..add(event.workspace);
    emit(WorkspaceState(items: updatedItems));
  }

  Future<FutureOr<void>> _onRemoveWorkspace(RemoveWorkspaceEvent event, Emitter<WorkspaceState> emit) async {
    // Check if the file exists and delete it
    if (event.workspace.locatedAt != null) {
      final file = File(event.workspace.locatedAt!);
      if (await file.exists()) {
        await file.delete();
      }
    }

    // Remove the workspace from the state
    final updatedItems = state.items.where((item) => item != event.workspace).toList();
    emit(WorkspaceState(items: updatedItems));
  }
}
