import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:edit_skin_melon/core/di/di.dart';
import 'package:edit_skin_melon/core/utils/functions/asset_loader.dart';
import 'package:edit_skin_melon/core/utils/helpers/base_x_codec_helper.dart';
import 'package:edit_skin_melon/core/utils/helpers/storage_helper.dart';
import 'package:edit_skin_melon/features/home/blocs/workspace/workspace_bloc.dart';
import 'package:edit_skin_melon/features/home/models/workspace_model.dart';
import 'package:edit_skin_melon/features/skin_editor/blocs/skin_part/skin_part_bloc.dart';
import 'package:edit_skin_melon/features/skin_editor/models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image/image.dart' as img;
import 'package:injectable/injectable.dart';
import 'package:name_plus/name_plus.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:replay_bloc/replay_bloc.dart';
import 'package:screenshot/screenshot.dart';

import '../../widgets/melon_game_widget.dart';

part 'skin_editor_event.dart';
part 'skin_editor_state.dart';

@injectable
class SkinEditorBloc extends Bloc<SkinEditorEvent, SkinEditorState> {
  final ScreenshotController screenshotController = ScreenshotController();
  Uint8List? imageScreenshot;

  SkinEditorBloc() : super(const SkinEditorState()) {
    on<SkinEditorInitialEvent>(_onSkinEditorInitialEvent);
    on<SkinEditorUpdatePartEvent>(_onSkinEditorUpdatePartEvent);
    on<SkinEditorUpdateCategoryEvent>(_onSkinEditorUpdateCategoryEvent);
    on<SkinEditorSwitchAllPartsPropertiesEvent>(_onSkinEditorSwitchAllPartsPropertiesEvent);
    on<SkinEditorChangeIconEvent>(_onSkinEditorChangeIconEvent);
    on<SkinEditorSaveEvent>(_onSkinEditorSaveEvent, transformer: droppable());

    /// ---------------------
    on<SkinEditorIsShowPartEvent>(_onSkinEditorIsShowPartEvent);
    on<SkinEditorSwitchIsDrawableEvent>(_onSkinEditorSwitchIsDrawableEvent);
    on<SkinEditorPickColorEvent>(_onSkinEditorPickColorEvent);
    on<SkinEditorAddHistoryColorEvent>(_onSkinEditorAddHistoryColorEvent);
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
      status: SkinEditorStatusState.initial,
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
    emit(state.copyWith(
      isShowPart: state.isShowPart.map((e) => true).toList(),
      isShowGrid: false,
    ));

    if (event.parts.isEmpty) return;

    var parts = event.parts.map((element) {
      return element.copyWith(
        mainTextureUint8List: element.mainTextureUint8List,
        mainTextureHeight: element.mainTextureHeight,
        mainTextureWidth: element.mainTextureWidth,
      );
    }).toList();

    // get icon from first part (head)
    List<int>? icon = event.parts.first.mainTextureUint8List;

    await _captureScreen(event.context);

    emit(
      state.copyWith(
        projectItem: state.projectItem?.copyWith(icon: icon, parts: parts),
        imageScreenshot: imageScreenshot,
      ),
    );
  }

  FutureOr<void> _onSkinEditorUpdateCategoryEvent(SkinEditorUpdateCategoryEvent event, Emitter<SkinEditorState> emit) {
    emit(state.copyWith(projectItem: state.projectItem?.copyWith(category: event.category)));
  }

  FutureOr<void> _onSkinEditorSwitchAllPartsPropertiesEvent(
      SkinEditorSwitchAllPartsPropertiesEvent event, Emitter<SkinEditorState> emit) {
    final parts = state.projectItem?.parts?.map((element) {
      return element.copyWith(
        canBurn: event.property == 'canBurn' ? event.value : element.canBurn,
        canFloat: event.property == 'canFloat' ? event.value : element.canFloat,
      );
    }).toList();

    emit(state.copyWith(projectItem: state.projectItem?.copyWith(parts: parts)));
  }

  FutureOr<void> _onSkinEditorChangeIconEvent(SkinEditorChangeIconEvent event, Emitter<SkinEditorState> emit) async {
    emit(state.copyWith(projectItem: state.projectItem?.copyWith(icon: event.icon)));
  }

  Future<FutureOr<void>> _onSkinEditorSaveEvent(SkinEditorSaveEvent event, Emitter<SkinEditorState> emit) async {
    EasyLoading.show();

    final dir = await StorageHelper.getSavedDirectory();
    final dirEdits = Directory(path.join(dir.path, 'Edits'));
    if (!dirEdits.existsSync()) await dirEdits.create();

    try {
      final uniqueId = "${event.name}${DateTime.now().year}${DateTime.now().millisecondsSinceEpoch}";
      final modFile = await File(dirEdits.path).namePlus("${event.name}.melmod", format: '(d)', space: false);

      // Update projectItem with new name and custom category
      state.copyWith(
        projectItem: state.projectItem?.copyWith(
          uniqueId: uniqueId,
          customCategory: event.categoryCustom,
        ),
      );

      await _createFileMelMod(state.projectItem!, modFile.path);

      final WorkspaceModel workspaceModel = WorkspaceModel(
        name: modFile.name,
        image: state.imageScreenshot,
        locatedAt: modFile.path,
      );

      getIt<WorkspaceBloc>().add(AddWorkspaceEvent(workspaceModel));

      emit(state.copyWith(status: SkinEditorStatusState.complete));
    } catch (e) {
      // snack bar error
    }
    EasyLoading.dismiss();
  }

  Future<void> _createFileMelMod(ProjectItem projectItem, String path) async {
    var projectItemJson = await _preProcessProjectItem(projectItem);
    await _writeProjectItemToFile(projectItemJson, path);
  }

  Future<String> _preProcessProjectItem(ProjectItem projectItem) async {
    // Pre-process projectItem
    // ...
    var parts = projectItem.parts!.map((e) async {
      return e.copyWith(mainTexture: await BaseXCodecHelper().encodeBaseWithIsolate(e.mainTextureUint8List!));
    }).toList();

    projectItem = projectItem.copyWith(parts: await Future.wait(parts));

    return projectItem.toJson();
  }

  Future<void> _writeProjectItemToFile(String projectItemJson, String path) async {
    final File file = File(path);
    await file.writeAsString(projectItemJson);
  }

  Future<void> _captureScreen(BuildContext context) async {
    await screenshotController
        .captureFromWidget(
      _buildCaptureWidget(context),
      context: context,
      delay: const Duration(milliseconds: 20),
      pixelRatio: 1,
      targetSize: const Size(412, 900),
    )
        .then((Uint8List? image) async {
      if (image != null) {
        log('Image captured');

        final directory = await getApplicationDocumentsDirectory();
        final imagePath = await File('${directory.path}/image.jpg').create();

        // img.Image? decodeImage = img.decodeImage(image);
        // if (decodeImage != null) {
        //
        //   decodeImage = img.copyResize(decodeImage, width: 256);
        //   image = Uint8List.fromList(img.encodePng(decodeImage));
        // }
        log('Image path: ${imagePath.path}');
        await imagePath.writeAsBytes(image);
        imageScreenshot = image;
      }
    });
  }

  Widget _buildCaptureWidget(BuildContext context) {
    return GameWidget(
      game: MelonGame(
        skinEditorBloc: context.read<SkinEditorBloc>(),
        skinPartBloc: context.read<SkinPartBloc>(),
        isCapture: true,
      ),
    );
  }

  FutureOr<void> _onSkinEditorAddHistoryColorEvent(
      SkinEditorAddHistoryColorEvent event, Emitter<SkinEditorState> emit) {
    final historyColorDraw = List<Color>.from(state.historyColorDraw ?? []);
    historyColorDraw.add(state.colorDraw);
    emit(state.copyWith(historyColorDraw: historyColorDraw));
  }
}

extension FileNameExtension on File {
  String get name {
    return path.split('/').last;
  }
}
