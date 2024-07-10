import 'dart:async';

import 'package:edit_skin_melon/core/utils/functions/any_functions.dart';
import 'package:edit_skin_melon/features/skin_editor/models/models.dart';
import 'package:edit_skin_melon/packages/flutter_easyloading/flutter_easyloading.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'skin_editor_event.dart';

part 'skin_editor_state.dart';

@lazySingleton
class SkinEditorBloc extends Bloc<SkinEditorEvent, SkinEditorState> {

  SkinEditorBloc() : super(const SkinEditorState.initial()) {
    on<SkinEditorInitialEvent>(_onSkinEditorInitialEvent);
  }

  FutureOr<void> _onSkinEditorInitialEvent(SkinEditorInitialEvent event, Emitter<SkinEditorState> emit) async {
    EasyLoading.show();

    final content = await loadAsset(event.pathDefault);
    ProjectItem projectItem = ProjectItem.fromJson(content);

    emit(state.copyWith(projectItem: projectItem, isLoading: false));
    EasyLoading.dismiss();
  }
}
