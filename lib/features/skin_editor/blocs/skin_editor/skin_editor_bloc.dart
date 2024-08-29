import 'dart:async';
import 'dart:developer' as dev;

import 'package:edit_skin_melon/core/utils/helpers/file_download_helper.dart';
import 'package:edit_skin_melon/core/utils/functions/any_functions.dart';
import 'package:edit_skin_melon/features/skin_editor/models/models.dart';
import 'package:edit_skin_melon/packages/flutter_easyloading/flutter_easyloading.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:injectable/injectable.dart';
import 'package:replay_bloc/replay_bloc.dart';

part 'skin_editor_event.dart';

part 'skin_editor_state.dart';

@lazySingleton
class SkinEditorBloc extends Bloc<SkinEditorEvent, SkinEditorState> {
  SkinEditorBloc() : super(const SkinEditorState()) {
    on<SkinEditorInitialEvent>(_onSkinEditorInitialEvent);
    on<SkinEditorUpdateAvailableModelEvent>(_onSkinEditorUpdateEvent);
    on<SkinEditorBlendColorEvent>(_onSkinEditorBlendColorEvent);
    on<SkinEditorSwitchIsDrawableEvent>(_onSkinEditorSwitchIsDrawableEvent);
    on<SkinEditorPickColorEvent>(_onSkinEditorPickColorEvent);
    // on<SkinEditorToPngEvent>(_onSkinEditorToPngEvent);
  }

  Future<void> _onSkinEditorInitialEvent(SkinEditorInitialEvent event, Emitter<SkinEditorState> emit) async {
    EasyLoading.show();

    final content = await AnyFunction.loadAsset("assets/textures/default.melmod");
    ProjectItem projectItem = ProjectItem.fromJson(content);

    emit(state.copyWith(projectItem: projectItem, isLoading: false));

    EasyLoading.dismiss();
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

  FutureOr<void> _onSkinEditorBlendColorEvent(SkinEditorBlendColorEvent event, Emitter<SkinEditorState> emit) {
    final partEdited = state.projectItem?.parts?[event.indexPart];

    emit(
      state.copyWith(
        projectItem: state.projectItem?.copyWith(
          parts: state.projectItem?.parts
              ?.map((part) => part == partEdited ? part.copyWith(mainTextureUint8List: event.data) : part)
              .toList(),
        ),
      ),
    );
  }

  FutureOr<void> _onSkinEditorSwitchIsDrawableEvent(
      SkinEditorSwitchIsDrawableEvent event, Emitter<SkinEditorState> emit) {
    emit(state.copyWith(isDrawable: !state.isDrawable));
  }

  FutureOr<void> _onSkinEditorPickColorEvent(SkinEditorPickColorEvent event, Emitter<SkinEditorState> emit) {
    emit(state.copyWith(colorDraw: event.color));
  }
}
