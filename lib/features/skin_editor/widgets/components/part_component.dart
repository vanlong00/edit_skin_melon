import 'package:edit_skin_melon/features/skin_editor/widgets/components/part_sprite_component.dart';
import 'package:edit_skin_melon/features/skin_editor/widgets/melon_game_widget.dart';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';

import '../../blocs/skin_editor/skin_editor_bloc.dart';
import '../../models/models.dart';
import '../../utils/constant.dart';

class PartComponent extends PositionComponent
    with HasGameRef<MelonGame>, FlameBlocListenable<SkinEditorBloc, SkinEditorState> {
  PartComponent(
    this.part, {
    Vector2? position,
    Vector2? size,
    int? priority,
  }) : super(
          position: position,
          size: size,
          priority: priority,
        );

  final Part part;

  @override
  Future<void> onLoad() async {
    position = position * AppGameConstant.MAX_PER_UINT;

    final partMelon = PartSpriteComponent(
      part: part,
      position: size / 2,
    );

    add(partMelon);
    return super.onLoad();
  }
}
