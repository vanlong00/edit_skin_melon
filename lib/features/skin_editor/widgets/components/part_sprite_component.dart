import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:edit_skin_melon/core/di/di.dart';
import 'package:edit_skin_melon/features/skin_editor/blocs/skin_editor/skin_editor_bloc.dart';
import 'package:edit_skin_melon/features/skin_editor/blocs/skin_item/skin_item_bloc.dart';
import 'package:edit_skin_melon/features/skin_editor/widgets/components/part_component.dart';
import 'package:edit_skin_melon/features/skin_editor/widgets/melon_game_widget.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

import '../../blocs/skin_part/skin_part_bloc.dart';
import '../../models/models.dart';
import '../../utils/constant.dart';
import '../../utils/image_manipulator.dart';
import 'gird_component.dart';

class PartSpriteComponent extends SpriteComponent
    with HasGameRef<MelonGame>, TapCallbacks, ParentIsA<PartComponent>, HasVisibility {
  PartSpriteComponent({
    required this.index,
    super.position,
  }) : super(anchor: Anchor.center);

  final int index;
  bool isEventTexture = false;

  img.Image? pix;
  Uint8List? pixData;

  /// ----------------- Tap Detector -----------------
  @override
  void onTapUp(TapUpEvent event) {
    if (!isVisible) return;

    // TODO: implement onTapUp
    if (gameRef.isDrawable == false) {
      getIt<SkinItemBloc>().add(SkinItemSelect(indexPart: index));
    }

    super.onTapUp(event);
  }

  @override
  Future<void> onTapDown(TapDownEvent event) async {
    if (!isVisible) return;

    if (gameRef.isDrawable == true) {
      final Vector2 localPos = convertGlobalToLocal(event.canvasPosition);
      pix = img.decodeImage(gameRef.skinPartBloc.state.parts![index].mainTextureUint8List!);

      // Update the sprite with the brush
      updateSpriteWithBrush(localPos);

      resetPixData();
      return;
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

    // Update the sprite with the brush
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

    add(
      FlameBlocListener<SkinItemBloc, SkinItemState>(
        onNewState: onNewStateSkinItem,
        listenWhen: listenWhenSkinItem,
        onInitialState: onInitialStateSkinItem,
        bloc: gameRef.skinItemBloc,
      ),
    );
  }

  /// ----------------- SkinEditorBloc -----------------
  bool listenWhenSkinEditor(SkinEditorState previousState, SkinEditorState newState) {
    /// Check if the grid is enabled
    if (previousState.isShowGrid != newState.isShowGrid) {
      updateGridLayer(newState);
    }

    /// Checks if the drawable state has changed between the previous and new states.
    if (previousState.isDrawable != newState.isDrawable) {
      /// If the new state allows drawing, remove any opacity effects.
      if (newState.isDrawable) {
        removeEffectOpacity();
      }

      /// If drawing is not allowed, update the component's priority and apply an opacity effect.
      else if (!newState.isDrawable) {
        updatePriorityAndOpacity((gameRef.skinItemBloc.state as SkinItemLoaded).indexPart);
      }
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
  void onInitialStateSkinPart(SkinPartState state) {
    priority = AppGameConstant.MAX_PRIORITY_PART - index;
  }

  Future<void> onNewStateSkinPart(SkinPartState state) async {
    if (isEventTexture) {
      final newPart = state.parts![index];
      parent.part = newPart;
      sprite = await createSpriteFromData(parent.part.mainTextureUint8List!);
      size = sprite!.originalSize * AppGameConstant.MAX_PER_UINT / parent.part.pixelsPerUnit!;
      // update the grid layer
      updateGridLayer(gameRef.skinEditorBloc.state);

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
    removeWhere((component) => component is GridComponent);

    if (state.isShowGrid) {
      showGridLayer();
    }
  }

  void showGridLayer() {
    add(GridComponent(
      rows: sprite!.originalSize.y.toInt(),
      columns: sprite!.originalSize.x.toInt(),
      cellSize: 1.0 * AppGameConstant.MAX_PER_UINT / parent.part.pixelsPerUnit!, // Adjust the cell size as needed
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

    bool hasPixel = ImageManipulator.hasPixel(localPos.x.toInt(), localPos.y.toInt(), pix!);

    if (hasPixel) {
      pix = ImageManipulator.applyBrush(
        localPos.x.toInt(),
        localPos.y.toInt(),
        gameRef.skinEditorBloc.state.colorDraw,
        pix!,
        // parent.part.pixelsPerUnit! ~/ AppGameConstant.MAX_PRIORITY_PART,
        0,
      );

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

  // Add the [OpacityEffect] to the component.
  void addEffectOpacity({double? opacity}) {
    add(OpacityEffect.to(opacity ?? 0.3, EffectController(duration: 0)));
  }

  // Remove the [OpacityEffect] from the component.
  void removeEffectOpacity() {
    add(OpacityEffect.to(1, EffectController(duration: 0)));
  }

  void updatePriorityAndOpacity(int currentIndex) {
    if (currentIndex != index) {
      priority = 50 + index;
      addEffectOpacity();
    } else {
      priority = 100;
      removeEffectOpacity();
    }
  }

  /// ----------------- End Function Component --------------

  void onNewStateSkinItem(SkinItemState state) {
    updatePriorityAndOpacity((state as SkinItemLoaded).indexPart);
  }

  bool listenWhenSkinItem(SkinItemState previousState, SkinItemState newState) {
    if (previousState is SkinItemLoaded && newState is SkinItemLoaded) {
      return previousState.indexPart != newState.indexPart;
    }

    return false;
  }

  void onInitialStateSkinItem(SkinItemState state) {
    updatePriorityAndOpacity((state as SkinItemLoaded).indexPart);

    if (gameRef.isCapture) {
      removeEffectOpacity();
    }
  }
}
