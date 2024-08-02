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

class MelonGame extends FlameGame with ScaleDetector {
  final pauseOverlayIdentifier = 'Next';
  late double startZoom;
  PartSpriteComponent? spriteComponent;

  @override
  Color backgroundColor() => AppColor.backgroundGame;

  @override
  Future<void> onLoad() async {
    overlays.add(pauseOverlayIdentifier);
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
    debugMode = true;
    return super.onLoad();
  }

  void clampZoom() {
    camera.viewfinder.zoom = camera.viewfinder.zoom.clamp(AppGameConstant.MIN_ZOOM, AppGameConstant.MAX_ZOOM);
  }

  @override
  void onScaleStart(ScaleStartInfo info) {
    startZoom = camera.viewfinder.zoom;
    spriteComponent = componentsAtPoint(info.eventPosition.widget).whereType<PartSpriteComponent>().firstOrNull;
    spriteComponent?.onScaleStart(info);
    super.onScaleStart(info);
  }

  @override
  void onScaleEnd(ScaleEndInfo info) {
    spriteComponent?.onScaleEnd(info);
    spriteComponent = null;
    super.onScaleEnd(info);
  }

  @override
  void onScaleUpdate(ScaleUpdateInfo info) {
    if (info.pointerCount == 1) {
      if (spriteComponent != null) {
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