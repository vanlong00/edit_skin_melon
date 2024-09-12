import 'package:edit_skin_melon/features/skin_editor/widgets/components/part_sprite_component.dart';
import 'package:edit_skin_melon/features/skin_editor/widgets/melon_game_widget.dart';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';

import '../../blocs/skin_editor/skin_editor_bloc.dart';
import '../../models/models.dart';
import '../../utils/constant.dart';

class PartComponent extends PositionComponent with HasGameRef<MelonGame> {
  PartComponent(
    this.part, {
    super.priority,
    super.position,
  });

  Part part;

  @override
  Future<void> onLoad() async {
    // position = position * AppGameConstant.MAX_PER_UINT;
    position = position * AppGameConstant.MAX_PER_UINT;

    final partMelon = PartSpriteComponent();

    add(partMelon);
    return super.onLoad();
  }
}
