import 'dart:ui' as ui;

import 'package:edit_skin_melon/features/skin_editor/blocs/skin_editor_bloc.dart';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

import '../models/models.dart';

class PartComponent extends SpriteComponent with FlameBlocListenable<SkinEditorBloc, SkinEditorState> {
  PartComponent({
    required this.part,
    Vector2? position,
  }) : super(
          position: position,
          anchor: Anchor.center,
        );

  final Part part;
  late int index;
  bool isEventTexture = false;

  @override
  bool listenWhen(SkinEditorState previousState, SkinEditorState newState) {
    if (index != 0) return false;

    final previousTexture = previousState.projectItem!.parts![index].mainTextureUint8List;
    final newTexture = newState.projectItem!.parts![index].mainTextureUint8List;

    if (previousTexture != newTexture) {
      isEventTexture = true;
    }

    return isEventTexture;
  }

  @override
  Future<void> onNewState(SkinEditorState state) async {
    if (isEventTexture) {
      print("PART COMPONENT: $index");
      var newPart = state.projectItem!.parts![index];
      print(newPart.mainTextureUint8List == part.mainTextureUint8List);
      sprite = await createSpriteFromPart(newPart);
      isEventTexture = false;
    }
    super.onNewState(state);
  }

  @override
  void onInitialState(SkinEditorState state) {
    index = state.projectItem!.parts!.indexOf(part);
    super.onInitialState(state);
  }

  @override
  Future<void> onLoad() async {
    sprite = await createSpriteFromPart(part);
    return super.onLoad();
  }

  Future<Sprite> createSpriteFromPart(Part part) async {
    ui.Image image = await decodeImageFromList(part.mainTextureUint8List!);
    return Sprite(image);
  }
}
