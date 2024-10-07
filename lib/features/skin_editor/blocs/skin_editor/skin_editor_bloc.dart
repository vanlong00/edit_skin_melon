import 'dart:async';

import 'package:edit_skin_melon/core/utils/functions/asset_loader.dart';
import 'package:edit_skin_melon/features/skin_editor/blocs/skin_part/skin_part_bloc.dart';
import 'package:edit_skin_melon/features/skin_editor/models/models.dart';
import 'package:edit_skin_melon/features/skin_editor/utils/constant.dart';
import 'package:edit_skin_melon/packages/flutter_easyloading/flutter_easyloading.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:replay_bloc/replay_bloc.dart';

part 'skin_editor_event.dart';

part 'skin_editor_state.dart';

@injectable
class SkinEditorBloc extends Bloc<SkinEditorEvent, SkinEditorState> {
  SkinEditorBloc() : super(const SkinEditorState()) {
    on<SkinEditorInitialEvent>(_onSkinEditorInitialEvent);
    on<SkinEditorUpdatePartEvent>(_onSkinEditorUpdatePartEvent);
    on<SkinEditorUpdateCategoryEvent>(_onSkinEditorUpdateCategoryEvent);
    on<SkinEditorSwitchAllPartsPropertiesEvent>(_onSkinEditorSwitchAllPartsPropertiesEvent);

    /// ---------------------
    on<SkinEditorIsShowPartEvent>(_onSkinEditorIsShowPartEvent);
    on<SkinEditorSwitchIsDrawableEvent>(_onSkinEditorSwitchIsDrawableEvent);
    on<SkinEditorPickColorEvent>(_onSkinEditorPickColorEvent);
    on<SkinEditorSwitchIsShowGridEvent>(_onSkinEditorSwitchIsShowGridEvent);
  }

  Future<void> _onSkinEditorInitialEvent(SkinEditorInitialEvent event, Emitter<SkinEditorState> emit) async {
    EasyLoading.show();

    final content = await AssetLoader.loadAsset(event.pathDefault);
    ProjectItem projectItem = ProjectItem.fromJson(content);
    List<bool> isShowPart = List.generate(projectItem.parts?.length ?? 0, (index) => true);

    emit(state.copyWith(
      projectItem: projectItem,
      isShowPart: isShowPart,
    ));

    EasyLoading.dismiss();

    /// ---------------------
    /// initial bloc skin part
    BuildContext context = event.context;
    if (!context.mounted) return;
    context.read<SkinPartBloc>().add(SkinPartEventInitialEvent(projectItem.parts ?? []));
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

  FutureOr<void> _onSkinEditorUpdatePartEvent(SkinEditorUpdatePartEvent event, Emitter<SkinEditorState> emit) async {
    if (event.parts.isEmpty) return;

    var parts = state.projectItem?.parts?.map((element) {
      return element.copyWith(
        mainTextureUint8List: element.mainTextureUint8List,
        mainTextureHeight: element.mainTextureHeight,
        mainTextureWidth: element.mainTextureWidth,
      );
    }).toList();

    // get icon from first part (head)
    List<int>? icon;
    if (event.parts.first.mainTextureUint8List != AppEditorConstant.iconDefault) {
      icon = event.parts.first.mainTextureUint8List;
    }

    emit(
      state.copyWith(
        projectItem: state.projectItem?.copyWith(
          icon: icon,
          parts: parts,
        ),
      ),
    );
  }

  FutureOr<void> _onSkinEditorUpdateCategoryEvent(SkinEditorUpdateCategoryEvent event, Emitter<SkinEditorState> emit) {
    emit(
      state.copyWith(
        projectItem: state.projectItem?.copyWith(
          category: event.category,
        ),
      ),
    );
  }

  FutureOr<void> _onSkinEditorSwitchAllPartsPropertiesEvent(SkinEditorSwitchAllPartsPropertiesEvent event, Emitter<SkinEditorState> emit) {
    final parts = state.projectItem?.parts?.map((element) {
      return element.copyWith(
        canBurn: event.property == 'canBurn' ? event.value : element.canBurn,
        canFloat: event.property == 'canFloat' ? event.value : element.canFloat,
      );
    }).toList();

    emit(
      state.copyWith(
        projectItem: state.projectItem?.copyWith(
          parts: parts,
        ),
      ),
    );
  }
}
