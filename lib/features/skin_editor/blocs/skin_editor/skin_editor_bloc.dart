import 'dart:async';
import 'dart:typed_data';
import 'dart:developer' as dev;

import 'package:edit_skin_melon/core/utils/classes/file_download_helper.dart';
import 'package:edit_skin_melon/core/utils/functions/any_functions.dart';
import 'package:edit_skin_melon/features/skin_editor/models/models.dart';
import 'package:edit_skin_melon/packages/flutter_easyloading/flutter_easyloading.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:image/image.dart' as img;

part 'skin_editor_state.dart';

part 'skin_editor_event.dart';

@lazySingleton
class SkinEditorBloc extends Bloc<SkinEditorEvent, SkinEditorState> {
  SkinEditorBloc() : super(const SkinEditorState.initial()) {
    on<SkinEditorInitialEvent>(_onSkinEditorInitialEvent);
    on<SkinEditorChangeSkinEvent>(_onSkinEditorChangeSkinEvent);
    on<SkinEditorToPngEvent>(_onSkinEditorToPngEvent);
  }

  Future<void> _onSkinEditorInitialEvent(SkinEditorInitialEvent event, Emitter<SkinEditorState> emit) async {
    EasyLoading.show();

    final content = await AnyFunction.loadAsset("assets/textures/RMA PLAYER HOME LS.melmod");
    ProjectItem projectItem = ProjectItem.fromJson(content);

    emit(state.copyWith(projectItem: projectItem, isLoading: false));
    EasyLoading.dismiss();
  }

  Future<void> _onSkinEditorChangeSkinEvent(SkinEditorChangeSkinEvent event, Emitter<SkinEditorState> emit) async {
    img.Image? skinImg = img.decodeImage(Uint8List.fromList(event.skin));
    img.Image? defaultSkinImg = img.decodeImage(state.projectItem!.parts![0].mainTextureUint8List!);

    img.Image result = img.compositeImage(defaultSkinImg!, skinImg!, center: true);
    Uint8List resultUint8List = img.encodePng(result);

    var partFirst = state.projectItem!.parts![0];

    emit(state.copyWith(
      projectItem: state.projectItem!.copyWith(
        parts: List<Part>.from(state.projectItem!.parts!.map((e) {
          if (e == partFirst) {
            return partFirst.copyWith(mainTextureUint8List: resultUint8List);
          }
          return e;
        })),
      ),
    ));
  }

  Future<void> _onSkinEditorToPngEvent(SkinEditorToPngEvent event, Emitter<SkinEditorState> emit) async {
    try {
      // final granted = await PermissionHelper.requestStoragePermissions();
      // if (!granted) return;

      for (var index = 0, parts = state.projectItem!.parts!; index < parts.length; index++) {
        final element = parts[index];
        await saveImage(index, element);
        await saveData(index, element);
      }
    } catch (e) {
      dev.log('Error saving file: $e');
    }
  }

  Future<void> saveData(int index, Part element) async => FileDownloaderHelper.saveFileAsStringOnDevice("data/skin$index.json", element.toJson2());

  Future<void> saveImage(int index, Part element) => FileDownloaderHelper.saveFileAsByteOnDevice("thumb/skin$index.png", element.mainTextureUint8List!);
}
