import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'melon_game_widget.dart';

class ViewGameWidget extends StatelessWidget {
  const ViewGameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: MelonGame(),
      overlayBuilderMap: {
        "Next": (context, game) => Positioned(
          right: 0,
          child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.arrow_forward),
              ),
        ),
      },
    );
  }
}
