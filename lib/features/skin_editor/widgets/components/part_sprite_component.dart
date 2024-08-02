import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:edit_skin_melon/features/skin_editor/blocs/skin_editor/skin_editor_bloc.dart';
import 'package:edit_skin_melon/features/skin_editor/widgets/melon_game_widget.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

import '../../../../core/di/di.dart';
import '../../models/models.dart';
import '../../utils/constant.dart';
import '../../utils/image_util.dart';

class PartSpriteComponent extends SpriteComponent
    with FlameBlocListenable<SkinEditorBloc, SkinEditorState>, HasGameRef<MelonGame>, TapCallbacks {
  PartSpriteComponent({
    required this.part,
    Vector2? position,
    required this.positionParent,
  }) : super(
          position: position,
          anchor: Anchor.center,
        );

  Part part;
  Vector2 positionParent;
  late int index;
  bool isEventTexture = false;

  img.Image? pix;
  Uint8List? pixData;


  Vector2 convertGlobalToLocal(Vector2 positionTo) {
    var zoom = game.camera.viewfinder.zoom;
    var zoomUnit = (game.size / 2) / zoom;

    var local = ((zoomUnit * 2)
          ..multiply(positionTo)
          ..divide(game.size)) -
        zoomUnit;

    var pos = local + game.camera.viewfinder.position + (size / 2) - positionParent;

    return pos * part.pixelsPerUnit! / AppGameConstant.MAX_PER_UINT;
  }

  void onScaleStart(ScaleStartInfo info) async {
    pix = img.decodeImage(part.mainTextureUint8List!);
  }

  void onScaleEnd(ScaleEndInfo info) {
    if (pix == null) return;
    if (pixData == null) return;

    getIt<SkinEditorBloc>().add(SkinEditorBlendColorEvent(index, data: pixData!));
    pixData = null;
    pix = null;
  }

  void onScaleUpdate(ScaleUpdateInfo info) async {
    Vector2 localPos = convertGlobalToLocal(info.eventPosition.widget);

    if (pix == null) return;

    bool hasPixel = ImageUtil.hasPixel(localPos.x.toInt(), localPos.y.toInt(), pix!);

    if (hasPixel) {
      pix = ImageUtil.applyBrush(localPos.x.toInt(), localPos.y.toInt(), Colors.red, pix!, 0);
      pixData = img.encodePng(pix!);
      sprite = await createSpriteFromData(pixData!);

    }
  }

  @override
  bool listenWhen(SkinEditorState previousState, SkinEditorState newState) {
    final previousTexture = previousState.projectItem!.parts![index].mainTextureUint8List;
    final newTexture = newState.projectItem!.parts![index].mainTextureUint8List;

    if (previousTexture != newTexture) {
      isEventTexture = true;
      return isEventTexture;
    }

    return super.listenWhen(previousState, newState);
  }

  @override
  Future<void> onNewState(SkinEditorState state) async {
    if (isEventTexture) {
      final newPart = state.projectItem!.parts![index];
      part = newPart;
      sprite = await createSpriteFromPart(part);
      size = sprite!.originalSize * AppGameConstant.MAX_PER_UINT / part.pixelsPerUnit!;
      isEventTexture = false;
    }
  }

  @override
  void onInitialState(SkinEditorState state) {
    index = state.projectItem!.parts!.indexOf(part);
    priority = 50 - index;
  }

  @override
  Future<void> onLoad() async {
    sprite = await createSpriteFromPart(part);
    size = sprite!.originalSize * AppGameConstant.MAX_PER_UINT / part.pixelsPerUnit!;
  }

  Future<Sprite> createSpriteFromPart(Part part) async {
    ui.Image image = await decodeImageFromList(part.mainTextureUint8List!);
    return Sprite(image);
  }

  Future<Sprite> createSpriteFromData(Uint8List data) async {
    ui.Image image = await decodeImageFromList(data);
    return Sprite(image);
  }
}
