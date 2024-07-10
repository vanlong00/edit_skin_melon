import 'package:edit_skin_melon/features/skin_editor/widgets/melon_game_widget.dart';
import 'package:edit_skin_melon/features/skin_editor/widgets/part_component.dart';
import 'package:flame/components.dart';

import '../models/models.dart';

class PIComponent extends PositionComponent with HasGameRef<MelonGame> {
  PIComponent(
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
    const maxPerUnit = 50.0;

    position = position * maxPerUnit;

    final partMelon = PartComponent(
      part: part,
      position: size / 2,
    );

    add(partMelon);
    return super.onLoad();
  }
}
