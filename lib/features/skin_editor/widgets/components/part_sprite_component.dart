import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:edit_skin_melon/features/skin_editor/blocs/skin_editor/skin_editor_bloc.dart';
import 'package:edit_skin_melon/features/skin_editor/widgets/components/part_component.dart';
import 'package:edit_skin_melon/features/skin_editor/widgets/melon_game_widget.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

import '../../blocs/skin_part/skin_part_bloc.dart';
import '../../models/models.dart';
import '../../utils/constant.dart';
import '../../utils/image_util.dart';
import 'gird_component.dart';

class PartSpriteComponent extends SpriteComponent
    with HasGameRef<MelonGame>, TapCallbacks, ParentIsA<PartComponent>, HasVisibility {
  PartSpriteComponent({
    super.position,
  }) : super(anchor: Anchor.center);

  late int index;
  bool isEventTexture = false;

  img.Image? pix;
  Uint8List? pixData;

  /// ----------------- Tap Detector -----------------
  @override
  void onTapUp(TapUpEvent event) {
    // TODO: implement onTapUp
    // getIt<SkinItemBloc>().add(SkinItemSelect(indexPart: index));
    super.onTapUp(event);
  }

  @override
  Future<void> onTapDown(TapDownEvent event) async {
    if (!isVisible) return;

    if (gameRef.isDrawable == true) {
      final Vector2 localPos = event.localPosition;
      pix = img.decodeImage(gameRef.skinPartBloc.state.parts![index].mainTextureUint8List!);

      /// Update the sprite with the brush
      updateSpriteWithBrush(localPos);

      resetPixData();
    }

    super.onTapDown(event);
  }

  /// ----------------- End Tap Detector -----------------

  /// ----------------- Pan Detector -----------------
  void onScaleStart(ScaleStartInfo info) async {
    pix = img.decodeImage(gameRef.skinPartBloc.state.parts![index].mainTextureUint8List!);
  }

  void onScaleEnd(ScaleEndInfo info) {
    resetPixData();
  }

  void onScaleUpdate(ScaleUpdateInfo info) async {
    Vector2 localPos = convertGlobalToLocal(info.eventPosition.widget);

    /// Update the sprite with the brush
    if (isVisible) updateSpriteWithBrush(localPos);
  }

  /// ----------------- End Pan Detector -----------------

  @override
  Future<void> onLoad() async {
    sprite = await createSpriteFromPart(parent.part);

    size = sprite!.originalSize * AppGameConstant.MAX_PER_UINT / parent.part.pixelsPerUnit!;

    add(
      FlameBlocListener<SkinPartBloc, SkinPartState>(
        onNewState: onNewStateSkinPart,
        listenWhen: listenWhenSkinPart,
        onInitialState: onInitialStateSkinPart,
        bloc: gameRef.skinPartBloc,
      ),
    );

    add(
      FlameBlocListener<SkinEditorBloc, SkinEditorState>(
        onNewState: onNewStateSkinEditor,
        listenWhen: listenWhenSkinEditor,
        onInitialState: onInitialStateSkinEditor,
        bloc: gameRef.skinEditorBloc,
      ),
    );
  }

  /// ----------------- SkinEditorBloc -----------------
  /// Listen to the state changes in the SkinEditorBloc
  bool listenWhenSkinEditor(SkinEditorState previousState, SkinEditorState newState) {
    /// Check if the grid is enabled
    if (previousState.isShowGrid != newState.isShowGrid) {
      updateGridLayer(newState);
    }

    /// Check if the part is visible
    if (previousState.isShowPart[index] != newState.isShowPart[index]) {
      isVisible = newState.isShowPart[index];
    }

    return false || isEventTexture;
  }

  Future<void> onNewStateSkinEditor(SkinEditorState state) async {}

  Future<void> onInitialStateSkinEditor(SkinEditorState state) async {
    /// Check if the part is visible
    isVisible = state.isShowPart[index];

    /// Check if the grid is enabled
    updateGridLayer(state);
  }

  /// ----------------- End SkinEditorBloc -----------------

  /// ----------------- SkinPartBloc -----------------
  /// Listen to the state changes in the SkinPartBloc
  void onInitialStateSkinPart(SkinPartState state) {
    index = state.parts!.indexOf(parent.part);
    priority = 50 - index;
  }

  Future<void> onNewStateSkinPart(SkinPartState state) async {
    if (isEventTexture) {
      final newPart = state.parts![index];
      parent.part = newPart;
      sprite = await createSpriteFromData(parent.part.mainTextureUint8List!);
      size = sprite!.originalSize * AppGameConstant.MAX_PER_UINT / parent.part.pixelsPerUnit!;
      isEventTexture = false;
    }
  }

  bool listenWhenSkinPart(SkinPartState previousState, SkinPartState newState) {
    final previousTexture = previousState.parts![index].mainTextureUint8List;
    final newTexture = newState.parts![index].mainTextureUint8List;

    if (previousTexture != newTexture) {
      isEventTexture = true;
    }

    return false || isEventTexture;
  }

  /// ----------------- End SkinPartBloc -----------------

  /// ----------------- Function Component -----------------
  void updateGridLayer(SkinEditorState state) {
    if (state.isShowGrid) {
      showGridLayer();
    } else {
      removeWhere((component) => component is GridComponent);
    }
  }

  void showGridLayer() {
    add(GridComponent(
      rows: sprite!.originalSize.y.toInt(),
      columns: sprite!.originalSize.x.toInt(),
      cellSize: 1.0, // Adjust the cell size as needed
    ));
  }

  Future<Sprite> createSpriteFromPart(Part part) async {
    ui.Image image = await decodeImageFromList(part.mainTextureUint8List!);
    return Sprite(image);
  }

  Future<Sprite> createSpriteFromData(Uint8List data) async {
    ui.Image image = await decodeImageFromList(data);
    return Sprite(image);
  }

  Vector2 convertGlobalToLocal(Vector2 positionTo) {
    var zoom = game.camera.viewfinder.zoom;
    var zoomUnit = (game.size / 2) / zoom;

    var local = ((zoomUnit * 2)
          ..multiply(positionTo)
          ..divide(game.size)) -
        zoomUnit;

    var pos = local + game.camera.viewfinder.position + (size / 2) - parent.position;

    return pos * parent.part.pixelsPerUnit! / AppGameConstant.MAX_PER_UINT;
  }

  void updateSpriteWithBrush(Vector2 localPos) async {
    if (pix == null) return;

    bool hasPixel = ImageUtil.hasPixel(localPos.x.toInt(), localPos.y.toInt(), pix!);

    if (hasPixel) {
      pix =
          ImageUtil.applyBrush(localPos.x.toInt(), localPos.y.toInt(), gameRef.skinEditorBloc.state.colorDraw, pix!, 0);
      pixData = img.encodePng(pix!);
      sprite = await createSpriteFromData(pixData!);
    }
  }

  void resetPixData() {
    if (pixData == null || pix == null) {
      return;
    }

    gameRef.skinPartBloc.add(SkinPartBlendColorEvent(index, data: pixData!));

    pixData = null;
    pix = null;
  }

  /// ----------------- End Function Component --------------
}
