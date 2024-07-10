import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

import '../models/models.dart';

class PartComponent extends SpriteComponent {
  PartComponent({
    required this.part,
    Vector2? position,
  }) : super(
          position: position,
          anchor: Anchor.center,
        );

  final Part part;

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
