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

import '../../../../core/di/di.dart';
import '../../blocs/skin_item/skin_item_bloc.dart';
import '../../models/models.dart';
import '../../utils/constant.dart';
import '../../utils/image_util.dart';

class PartSpriteComponent extends SpriteComponent with HasGameRef<MelonGame>, TapCallbacks, ParentIsA<PartComponent> {
  PartSpriteComponent({
    super.position,
  }) : super(
          anchor: Anchor.center,
        );

  late int index;
  bool isEventTexture = false;

  img.Image? pix;
  Uint8List? pixData;

  SkinEditorBloc get skinEditorBloc => getIt<SkinEditorBloc>();
  SkinItemBloc get skinItemBloc => getIt<SkinItemBloc>();

  @override
  void onTapUp(TapUpEvent event) {
    // TODO: implement onTapUp
    getIt<SkinItemBloc>().add(SkinItemSelect(indexPart: index));
    super.onTapUp(event);
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

  void onScaleStart(ScaleStartInfo info) async {
    pix = img.decodeImage(skinEditorBloc.state.projectItem!.parts![index].mainTextureUint8List!);
  }

  void onScaleEnd(ScaleEndInfo info) {
    if (pixData == null || pix == null) {
      return;
    }

    getIt<SkinEditorBloc>().add(SkinEditorBlendColorEvent(index, data: pixData!));

    pixData = null;
    pix = null;
  }

  void onScaleUpdate(ScaleUpdateInfo info) async {
    Vector2 localPos = convertGlobalToLocal(info.eventPosition.widget);

    if (pix == null) return;

    bool hasPixel = ImageUtil.hasPixel(localPos.x.toInt(), localPos.y.toInt(), pix!);

    if (hasPixel) {
      pix = ImageUtil.applyBrush(localPos.x.toInt(), localPos.y.toInt(), skinEditorBloc.state.colorDraw, pix!, 0);
      pixData = img.encodePng(pix!);
      sprite = await createSpriteFromData(pixData!);
    }
  }

  @override
  Future<void> onLoad() async {
    sprite = await createSpriteFromPart(parent.part);
    add(
      FlameBlocListener<SkinEditorBloc, SkinEditorState>(
        onNewState: onNewStateSkinEditor,
        listenWhen: listenWhenSkinEditor,
        onInitialState: onInitialStateSkinEditor,
        bloc: skinEditorBloc,
      ),
    );
  }

  Future<Sprite> createSpriteFromPart(Part part) async {
    ui.Image image = await decodeImageFromList(part.mainTextureUint8List!);
    return Sprite(image);
  }

  Future<Sprite> createSpriteFromData(Uint8List data) async {
    ui.Image image = await decodeImageFromList(data);
    return Sprite(image);
  }

  /// Listen to the state changes in the SkinEditorBloc
  bool listenWhenSkinEditor(SkinEditorState previousState, SkinEditorState newState) {
    /// Check if the texture has changed
    final previousTexture = previousState.projectItem!.parts![index].mainTextureUint8List;
    final newTexture = newState.projectItem!.parts![index].mainTextureUint8List;

    if (previousTexture != newTexture) {
      isEventTexture = true;
      return isEventTexture;
    }

    return true;
  }

  Future<void> onNewStateSkinEditor(SkinEditorState state) async {
    if (isEventTexture) {
      final newPart = state.projectItem!.parts![index];
      parent.part = newPart;
      sprite = await createSpriteFromPart(parent.part);
      size = sprite!.originalSize * AppGameConstant.MAX_PER_UINT / parent.part.pixelsPerUnit!;
      isEventTexture = false;
    }
  }

  Future<void> onInitialStateSkinEditor(SkinEditorState state) async {
    size = sprite!.originalSize * AppGameConstant.MAX_PER_UINT / parent.part.pixelsPerUnit!;
    index = state.projectItem!.parts!.indexOf(parent.part);
    priority = 50 - index;
  }
}
