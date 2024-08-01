import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:edit_skin_melon/features/skin_editor/blocs/skin_editor/skin_editor_bloc.dart';
import 'package:edit_skin_melon/features/skin_editor/blocs/skin_item/skin_item_bloc.dart';
import 'package:edit_skin_melon/features/skin_editor/utils/image_util.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image/image.dart' as img;

import '../../../core/di/di.dart';
import '../models/models.dart';
import '../utils/constant.dart';

class PartComponent extends SpriteComponent with FlameBlocListenable<SkinEditorBloc, SkinEditorState>, DragCallbacks {
  PartComponent({
    required this.part,
    Vector2? position,
  }) : super(
          position: position,
          anchor: Anchor.center,
        );

  Part part;
  late int index;
  bool isEventTexture = false;
  img.Image? imgImage;

  @override
  void onDragStart(DragStartEvent event) {
    // set imgImage
    imgImage = img.decodeImage(part.mainTextureUint8List!);
    super.onDragStart(event);
  }

  @override
  Future<void> onDragUpdate(DragUpdateEvent event) async {
    Vector2 localPos = event.localStartPosition;

    // Event blend color
    imgImage = ImageUtil.applyBrush(localPos.x.toInt(), localPos.y.toInt(), Colors.red, imgImage!, 0);
    Uint8List uint8List = img.encodePng(imgImage!);
    getIt<SkinEditorBloc>().add(SkinEditorBlendColorEvent(index, data: uint8List));

    super.onDragUpdate(event);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    // set imgImage to null
    imgImage = null;
    super.onDragEnd(event);
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
      size = sprite!.originalSize * maxPerUnit / part.pixelsPerUnit!;
      isEventTexture = false;
    }
  }

  @override
  void onInitialState(SkinEditorState state) {
    index = state.projectItem!.parts!.indexOf(part);
    priority = 50 - index;

    add(TapComponent(
      index: index,
      position: size / 2,
      size: size,
      anchor: Anchor.center,
    ));
  }

  @override
  Future<void> onLoad() async {
    sprite = await createSpriteFromPart(part);
    size = sprite!.originalSize * maxPerUnit / part.pixelsPerUnit!;
  }

  Future<Sprite> createSpriteFromPart(Part part) async {
    ui.Image image = await decodeImageFromList(part.mainTextureUint8List!);
    return Sprite(image);
  }
}

class TapComponent extends PositionComponent with TapCallbacks, FlameBlocListenable<SkinItemBloc, SkinItemState> {
  TapComponent({
    required this.index,
    Vector2? position,
    Vector2? size,
    int? priority,
    Anchor? anchor,
  }) : super(
          position: position,
          size: size,
          priority: priority,
          anchor: anchor,
        );

  final int index;

  @override
  void onTapDown(TapDownEvent event) {
    bloc.add(SkinItemSelectData(indexPart: index));
    event.continuePropagation = true;
    super.onTapDown(event);
  }
}

extension ColorHelp on int {
  int getRed() => this & 0xff;

  int getGreen() => (this >> 8) & 0xff;

  int getBlue() => (this >> 16) & 0xff;

  int getAlpha() => (this >> 24) & 0xff;

  img.Color getColor() => img.ColorUint32.rgba(getBlue(), getGreen(), getRed(), getAlpha());
}
