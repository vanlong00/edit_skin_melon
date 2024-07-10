import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'melon_game_widget.dart';

class ViewGameWidget extends StatelessWidget {
  const ViewGameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: MelonGame(),
    );
  }
}
