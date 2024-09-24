import 'dart:async';

import 'package:edit_skin_melon/core/utils/functions/any_functions.dart';
import 'package:edit_skin_melon/features/skin_editor/blocs/skin_part/skin_part_bloc.dart';
import 'package:edit_skin_melon/features/skin_editor/models/models.dart';
import 'package:edit_skin_melon/packages/flutter_easyloading/flutter_easyloading.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image/image.dart' as img;
import 'package:injectable/injectable.dart';
import 'package:replay_bloc/replay_bloc.dart';

part 'skin_editor_event.dart';
part 'skin_editor_state.dart';

@injectable
class SkinEditorBloc extends Bloc<SkinEditorEvent, SkinEditorState> {
  SkinEditorBloc() : super(const SkinEditorState()) {
    on<SkinEditorInitialEvent>(_onSkinEditorInitialEvent);
    on<SkinEditorUpdateAvailableModelEvent>(_onSkinEditorUpdateEvent);

    /// ---------------------
    on<SkinEditorIsShowPartEvent>(_onSkinEditorIsShowPartEvent);
    on<SkinEditorSwitchIsDrawableEvent>(_onSkinEditorSwitchIsDrawableEvent);
    on<SkinEditorPickColorEvent>(_onSkinEditorPickColorEvent);
    on<SkinEditorSwitchIsShowGridEvent>(_onSkinEditorSwitchIsShowGridEvent);
  }

  Future<void> _onSkinEditorInitialEvent(SkinEditorInitialEvent event, Emitter<SkinEditorState> emit) async {
    EasyLoading.show();

    final content = await AnyFunction.loadAsset("assets/textures/default.melmod");
    ProjectItem projectItem = ProjectItem.fromJson(content);
    List<bool> isShowPart = List.generate(projectItem.parts?.length ?? 0, (index) => true);

    emit(state.copyWith(
      projectItem: projectItem,
      isShowPart: isShowPart,
    ));

    EasyLoading.dismiss();

    event.context.read<SkinPartBloc>().add(SkinPartEventInitialEvent(projectItem.parts ?? []));
  }

  Future<FutureOr<void>> _onSkinEditorUpdateEvent(
      SkinEditorUpdateAvailableModelEvent event, Emitter<SkinEditorState> emit) async {
    final skin = await rootBundle.load(event.skinPath).then((value) => value.buffer.asUint8List());
    final data = await rootBundle.loadString(event.dataPath).then((value) => Part.fromJson(value));
    final image = img.decodeImage(skin);

    final newPart = data.copyWith(
      mainTextureUint8List: skin,
      mainTextureWidth: image?.width,
      mainTextureHeight: image?.height,
    );

    final partEdited = state.projectItem?.parts?[event.indexPart];

    emit(
      state.copyWith(
        projectItem: state.projectItem?.copyWith(
          parts: state.projectItem?.parts?.map((part) => part == partEdited ? newPart : part).toList(),
        ),
      ),
    );
  }

  FutureOr<void> _onSkinEditorIsShowPartEvent(SkinEditorIsShowPartEvent event, Emitter<SkinEditorState> emit) {
    final isShowPart = List<bool>.from(state.isShowPart);
    for (var index in event.indexPart) {
      isShowPart[index] = !isShowPart[index];
    }

    emit(state.copyWith(isShowPart: isShowPart));
  }

  FutureOr<void> _onSkinEditorSwitchIsDrawableEvent(
      SkinEditorSwitchIsDrawableEvent event, Emitter<SkinEditorState> emit) {
    emit(state.copyWith(isDrawable: !state.isDrawable));
  }

  FutureOr<void> _onSkinEditorPickColorEvent(SkinEditorPickColorEvent event, Emitter<SkinEditorState> emit) {
    emit(state.copyWith(colorDraw: event.color));
  }

  FutureOr<void> _onSkinEditorSwitchIsShowGridEvent(
      SkinEditorSwitchIsShowGridEvent event, Emitter<SkinEditorState> emit) {
    emit(state.copyWith(isShowGrid: !state.isShowGrid));
  }
}
