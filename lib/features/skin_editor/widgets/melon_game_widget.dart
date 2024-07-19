import 'dart:ui';

import 'package:edit_skin_melon/core/di/di.dart';
import 'package:edit_skin_melon/features/skin_editor/blocs/skin_editor/skin_editor_bloc.dart';
import 'package:edit_skin_melon/features/skin_editor/blocs/skin_item/skin_item_bloc.dart';
import 'package:edit_skin_melon/features/skin_editor/widgets/base.dart';
import 'package:edit_skin_melon/theme/app_color.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';

import '../utils/constant.dart';
import 'part_component.dart';

class MelonGame extends FlameGame with ScaleDetector {
  double startZoom = 1;
  PartComponent? partComponent;

  @override
  Color backgroundColor() => AppColor.backgroundGame;

  @override
  Future<void> onLoad() async {
    camera.viewfinder.zoom = 7.6;
    camera.moveTo(Vector2(0, 28));
    world.add(
      FlameMultiBlocProvider(
        providers: [
          FlameBlocProvider<SkinEditorBloc, SkinEditorState>.value(
            value: getIt<SkinEditorBloc>(),
          ),
          FlameBlocProvider<SkinItemBloc, SkinItemState>.value(
            value: getIt<SkinItemBloc>(),
          ),
        ],
        children: [Base()],
      ),
    );
    debugMode = true;
    return super.onLoad();
  }

  void clampZoom() {
    camera.viewfinder.zoom = camera.viewfinder.zoom.clamp(1, 50);
  }

  @override
  void onScaleStart(ScaleStartInfo info) {
    partComponent = componentsAtPoint(info.eventPosition.widget).whereType<PartComponent>().firstOrNull;
    startZoom = camera.viewfinder.zoom;
    super.onScaleStart(info);
  }

  @override
  void onScaleEnd(ScaleEndInfo info) {
    // TODO: implement onScaleEnd
    partComponent = null;
    super.onScaleEnd(info);
  }

  @override
  void onScaleUpdate(ScaleUpdateInfo info) {
    switch (info.pointerCount) {
      case 1:
        if (partComponent != null) {
          break;
        }
        final delta = info.delta.global;
        final zoomSpeed = 1 / camera.viewfinder.zoom;
        final adjustedDelta = delta * zoomSpeed * 0.6;
        camera.viewfinder.position += -adjustedDelta;
        break;
      case 2:
        final currentScale = info.scale.global;
        final newZoom = startZoom * currentScale.y;

        if (newZoom >= 0) {
          camera.viewfinder.zoom = newZoom;
          clampZoom();
        }
    }

    super.onScaleUpdate(info);
  }
}
