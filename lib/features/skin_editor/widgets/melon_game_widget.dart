import 'dart:ui';

import 'package:edit_skin_melon/core/di/di.dart';
import 'package:edit_skin_melon/features/skin_editor/blocs/skin_editor/skin_editor_bloc.dart';
import 'package:edit_skin_melon/features/skin_editor/blocs/skin_item/skin_item_bloc.dart';
import 'package:edit_skin_melon/features/skin_editor/widgets/components/foundation_component.dart';
import 'package:edit_skin_melon/theme/app_color.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';

class MelonGame extends FlameGame with ScaleDetector{
  double startZoom = 1;

  @override
  Color backgroundColor() => AppColor.backgroundGame;

  @override
  Future<void> onLoad() async {
    camera.viewfinder.zoom = 10;
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
        children: [FoundationComponent()],
      ),
    );
    debugMode = true;
    return super.onLoad();
  }

  void clampZoom() {
    camera.viewfinder.zoom = camera.viewfinder.zoom.clamp(1, 50);
  }
}
