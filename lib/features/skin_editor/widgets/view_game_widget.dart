import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/skin_editor/skin_editor_bloc.dart';
import '../blocs/skin_item/skin_item_bloc.dart';
import '../blocs/skin_part/skin_part_bloc.dart';
import 'melon_game_widget.dart';

class ViewGameWidget extends StatelessWidget {
  const ViewGameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: MelonGame(
        skinEditorBloc: context.read<SkinEditorBloc>(),
        skinPartBloc: context.read<SkinPartBloc>(),
        skinItemBloc: context.read<SkinItemBloc>(),
      ),
    );
  }
}
