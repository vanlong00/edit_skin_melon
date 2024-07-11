import 'dart:async';
import 'dart:typed_data';
import 'dart:developer' as dev;

import 'package:edit_skin_melon/core/di/di.dart';
import 'package:edit_skin_melon/core/utils/functions/any_functions.dart';
import 'package:edit_skin_melon/features/skin_editor/models/models.dart';
import 'package:edit_skin_melon/packages/flutter_easyloading/flutter_easyloading.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:image/image.dart' as img;

part 'skin_editor_event.dart';

part 'skin_editor_state.dart';

@lazySingleton
class SkinEditorBloc extends Bloc<SkinEditorEvent, SkinEditorState> {
  SkinEditorBloc() : super(const SkinEditorState.initial()) {
    on<SkinEditorInitialEvent>(_onSkinEditorInitialEvent);
    on<SkinEditorChangeSkinEvent>(_onSkinEditorChangeSkinEvent);
  }

  Future<void> _onSkinEditorInitialEvent(SkinEditorInitialEvent event, Emitter<SkinEditorState> emit) async {
    EasyLoading.show();

    final content = await AnyFunction.loadAsset(event.pathDefault);
    ProjectItem projectItem = ProjectItem.fromJson(content);

    emit(state.copyWith(projectItem: projectItem, isLoading: false));
    EasyLoading.dismiss();
  }

  Future<void> _onSkinEditorChangeSkinEvent(SkinEditorChangeSkinEvent event, Emitter<SkinEditorState> emit) async {
    // dev.log(event.skin.toString(), name: "SKIN");
    // dev.log(state.projectItem!.parts![0].mainTextureUint8List.toString(), name: "DEFAULT SKIN");

    var skinImg = img.decodeImage(Uint8List.fromList(event.skin));
    var defaultSkinImg = img.decodeImage(state.projectItem!.parts![0].mainTextureUint8List!);

    var result = img.compositeImage(defaultSkinImg!,skinImg! );
    var resultUint8List = img.encodePng(result);

    // dev.log(resultUint8List.toString(), name: "Result");

    print("SKIN EDITOR BLOC: ${state.projectItem!.parts![0].mainTextureUint8List! == resultUint8List}");

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
}
