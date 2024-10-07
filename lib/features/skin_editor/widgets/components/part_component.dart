import 'package:edit_skin_melon/features/skin_editor/widgets/components/part_sprite_component.dart';
import 'package:edit_skin_melon/features/skin_editor/widgets/melon_game_widget.dart';
import 'package:flame/components.dart';

import '../../models/models.dart';
import '../../utils/constant.dart';

class PartComponent extends PositionComponent with HasGameRef<MelonGame> {
  PartComponent(
    this.part, {
    required this.index,
    super.priority,
    super.position,
  });

  Part part;
  final int index;

  @override
  Future<void> onLoad() async {
    position = position * AppGameConstant.MAX_PER_UINT;

    final partMelon = PartSpriteComponent(index: index);

    add(partMelon);
    return super.onLoad();
  }
}
