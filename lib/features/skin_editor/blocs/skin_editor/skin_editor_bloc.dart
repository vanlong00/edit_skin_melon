import 'dart:async';
import 'dart:developer' as dev;

import 'package:edit_skin_melon/core/utils/classes/file_download_helper.dart';
import 'package:edit_skin_melon/core/utils/functions/any_functions.dart';
import 'package:edit_skin_melon/features/skin_editor/models/models.dart';
import 'package:edit_skin_melon/packages/flutter_easyloading/flutter_easyloading.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:image/image.dart' as img;
import 'package:replay_bloc/replay_bloc.dart';

part 'skin_editor_state.dart';

part 'skin_editor_event.dart';

@lazySingleton
class SkinEditorBloc extends ReplayBloc<SkinEditorEvent, SkinEditorState> {
  SkinEditorBloc() : super(const SkinEditorState.initial()) {
    on<SkinEditorInitialEvent>(_onSkinEditorInitialEvent);
    on<SkinEditorUpdatePartEvent>(_onSkinEditorUpdateEvent);
    on<SkinEditorBlendColorEvent>(_onSkinEditorBlendColorEvent);
    on<SkinEditorToPngEvent>(_onSkinEditorToPngEvent);
  }

  Future<void> _onSkinEditorInitialEvent(SkinEditorInitialEvent event, Emitter<SkinEditorState> emit) async {
    EasyLoading.show();

    final content = await AnyFunction.loadAsset("assets/textures/default.melmod");
    ProjectItem projectItem = ProjectItem.fromJson(content);

    emit(state.copyWith(projectItem: projectItem, isLoading: false));
    clearHistory();
    EasyLoading.dismiss();
  }

  Future<FutureOr<void>> _onSkinEditorUpdateEvent(
      SkinEditorUpdatePartEvent event, Emitter<SkinEditorState> emit) async {
    Uint8List skin = await rootBundle.load(event.skinPath).then((value) => value.buffer.asUint8List());
    Part data = await rootBundle.loadString(event.dataPath).then((value) => Part.fromJson(value));

    var image = img.decodeImage(skin);
    Part newPart = data.copyWith(
      mainTextureUint8List: skin,
      mainTextureWidth: image?.width,
      mainTextureHeight: image?.height,
    );

    emit(state.copyWith(
      projectItem: state.projectItem!.copyWith(
        parts: state.projectItem!.parts!.map((e) {
          if (e == state.projectItem!.parts![event.indexPart]) {
            return newPart;
          }
          return e;
        }).toList(),
      ),
    ));
  }

  FutureOr<void> _onSkinEditorBlendColorEvent(SkinEditorBlendColorEvent event, Emitter<SkinEditorState> emit) {

    emit(state.copyWith(
      projectItem: state.projectItem!.copyWith(
        parts: state.projectItem!.parts!.map((e) {
          if (e == state.projectItem!.parts![event.indexPart]) {
            return e.copyWith(mainTextureUint8List: event.data);
          }
          return e;
        }).toList(),
      ),
    ));
  }

  Future<void> _onSkinEditorToPngEvent(SkinEditorToPngEvent event, Emitter<SkinEditorState> emit) async {
    try {
      for (var index = 0, parts = state.projectItem!.parts!; index < parts.length; index++) {
        final element = parts[index];
        await saveImage(index, element);
        await saveData(index, element);
      }
    } catch (e) {
      dev.log('Error saving file: $e');
    }
  }

  Future<void> saveData(int index, Part element) async =>
      FileDownloaderHelper.saveFileAsStringOnDevice("data/skin$index.json", element.toJson2());

  Future<void> saveImage(int index, Part element) =>
      FileDownloaderHelper.saveFileAsByteOnDevice("thumb/skin$index.png", element.mainTextureUint8List!);
}
