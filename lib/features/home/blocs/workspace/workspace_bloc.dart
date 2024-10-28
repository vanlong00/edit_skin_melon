import 'dart:async';
import 'dart:io';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:edit_skin_melon/features/home/models/melon_model.dart';
import 'package:edit_skin_melon/features/home/models/workspace_model.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';

part 'workspace_event.dart';

part 'workspace_state.dart';

@lazySingleton
class WorkspaceBloc extends HydratedBloc<WorkspaceEvent, WorkspaceState> {
  WorkspaceBloc() : super(WorkspaceState.empty()) {
    on<AddWorkspaceEvent>(_onAddWorkspace, transformer: droppable());
    on<RemoveWorkspaceEvent>(_onRemoveWorkspace, transformer: droppable());
    on<AddMelonEvent>(_onAddMelon, transformer: droppable());
    on<RemoveMelonEvent>(_onRemoveMelon, transformer: droppable());
  }

  @override
  WorkspaceState? fromJson(Map<String, dynamic> json) {
    return WorkspaceState(
      workSpaceItems: (json['workSpaceItems'] as List<dynamic>).map((e) => WorkspaceModel.fromJson(e)).toList(),
      melonItems: (json['melonItems'] as List<dynamic>).map((e) => MelonModel.fromJson(e)).toList(),
    );
  }

  @override
  Map<String, dynamic>? toJson(WorkspaceState state) {
    return {
      'workSpaceItems': state.workSpaceItems.map((e) => e.toJson()).toList(),
      'melonItems': state.melonItems.map((e) => e.toJson()).toList(),
    };
  }

  FutureOr<void> _onAddWorkspace(AddWorkspaceEvent event, Emitter<WorkspaceState> emit) {
    final updatedItems = [event.workspace, ...state.workSpaceItems];
    emit(state.copyWith(workSpaceItems: updatedItems));
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
    final updatedItems = state.workSpaceItems.where((item) => item != event.workspace).toList();
    emit(state.copyWith(workSpaceItems: updatedItems));
  }

  FutureOr<void> _onRemoveMelon(RemoveMelonEvent event, Emitter<WorkspaceState> emit) {
    final updatedItems = state.melonItems.where((item) => item != event.melon).toList();
    emit(state.copyWith(melonItems: updatedItems));
  }

  Future<void> _onAddMelon(AddMelonEvent event, Emitter<WorkspaceState> emit) async {
    if (state.melonItems.contains(event.melon)) {
      return;
    }

    final updatedItems = [event.melon, ...state.melonItems];
    emit(state.copyWith(melonItems: updatedItems));
  }
}
