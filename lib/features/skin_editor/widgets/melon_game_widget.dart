import 'package:edit_skin_melon/core/di/di.dart';
import 'package:edit_skin_melon/features/skin_editor/blocs/skin_editor/skin_editor_bloc.dart';
import 'package:edit_skin_melon/features/skin_editor/widgets/base.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';

class MelonGame extends FlameGame with ScaleDetector {
  late double startZoom;

  @override
  Future<void> onLoad() async {
    camera.viewfinder.zoom = 4;
    camera.moveTo(Vector2(0, 28));
    world.add(
      FlameBlocProvider<SkinEditorBloc, SkinEditorState>(
        create: () => getIt<SkinEditorBloc>(),
        children: [Base()],
      ),
    );
    return super.onLoad();
  }

  void clampZoom() {
    camera.viewfinder.zoom = camera.viewfinder.zoom.clamp(0.1, 50);
  }

  @override
  void onScaleStart(ScaleStartInfo info) {
    startZoom = camera.viewfinder.zoom;
    super.onScaleStart(info);
  }

  @override
  void onScaleUpdate(ScaleUpdateInfo info) {
    final currentScale = info.scale.global;

    if (!currentScale.isIdentity()) {
      final newZoom = startZoom * currentScale.y;

      if (newZoom >= 0) {
        camera.viewfinder.zoom = newZoom;
        clampZoom();
      }
    } else {
      final delta = info.delta.global;
      final zoomSpeed = 1 / camera.viewfinder.zoom;
      final adjustedDelta = delta * zoomSpeed * 0.6;
      camera.viewfinder.position += -adjustedDelta;
    }
    super.onScaleUpdate(info);
  }
}
