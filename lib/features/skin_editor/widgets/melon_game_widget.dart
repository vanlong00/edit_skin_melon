import 'dart:ui';
import 'package:edit_skin_melon/core/di/di.dart';
import 'package:edit_skin_melon/features/skin_editor/blocs/skin_editor/skin_editor_bloc.dart';
import 'package:edit_skin_melon/features/skin_editor/blocs/skin_item/skin_item_bloc.dart';
import 'package:edit_skin_melon/features/skin_editor/utils/constant.dart';
import 'package:edit_skin_melon/features/skin_editor/widgets/components/foundation_component.dart';
import 'package:edit_skin_melon/features/skin_editor/widgets/components/part_sprite_component.dart';
import 'package:edit_skin_melon/theme/app_color.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/foundation.dart';

class MelonGame extends FlameGame with ScaleDetector {
  late double startZoom;

  PartSpriteComponent? spriteComponent;
  bool? isDrawable;

  @override
  Color backgroundColor() => AppColor.backgroundGame;

  @override
  Future<void> onLoad() async {
    camera.viewfinder.zoom = 7;
    camera.moveTo(Vector2(0, 32));

    world.add(
      FlameMultiBlocProvider(
        providers: [
          FlameBlocProvider<SkinEditorBloc, SkinEditorState>.value(value: getIt<SkinEditorBloc>()),
          FlameBlocProvider<SkinItemBloc, SkinItemState>.value(value: getIt<SkinItemBloc>()),
        ],
        children: [FoundationComponent()],
      ),
    );

    debugMode = kDebugMode;
    return super.onLoad();
  }

  void clampZoom() {
    camera.viewfinder.zoom = camera.viewfinder.zoom.clamp(AppGameConstant.MIN_ZOOM, AppGameConstant.MAX_ZOOM);
  }

  @override
  void onScaleStart(ScaleStartInfo info) {
    switch (info.pointerCount) {
      case 1:
        spriteComponent = componentsAtPoint(info.eventPosition.widget).whereType<PartSpriteComponent>().firstOrNull;
        spriteComponent?.onScaleStart(info);
        break;
      case 2:
        startZoom = camera.viewfinder.zoom;
        break;
    }

    super.onScaleStart(info);
  }

  @override
  void onScaleEnd(ScaleEndInfo info) {
    if (spriteComponent != null && isDrawable == true) {
      spriteComponent?.onScaleEnd(info);
      spriteComponent = null;
    }

    super.onScaleEnd(info);
  }

  @override
  void onScaleUpdate(ScaleUpdateInfo info) {
    if (info.pointerCount == 1) {
      if (spriteComponent != null && isDrawable == true) {
        spriteComponent?.onScaleUpdate(info);
      } else {
        final delta = info.delta.global * (1 / camera.viewfinder.zoom) * 0.6;
        camera.viewfinder.position += -delta;
      }
    } else if (info.pointerCount == 2) {
      final newZoom = startZoom * info.scale.global.y;
      if (newZoom > 0) camera.viewfinder.zoom = newZoom;
      clampZoom();
    }
    super.onScaleUpdate(info);
  }
}
