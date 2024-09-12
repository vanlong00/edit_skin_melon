import 'package:edit_skin_melon/features/skin_editor/blocs/skin_editor/skin_editor_bloc.dart';
import 'package:edit_skin_melon/features/skin_editor/widgets/melon_game_widget.dart';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';

import '../../models/models.dart';
import 'part_component.dart';

class FoundationComponent extends Component
    with FlameBlocListenable<SkinEditorBloc, SkinEditorState>, HasGameRef<MelonGame> {
  ProjectItem? projectItem;
  bool isEventIsDrawable = false;
  List<PartComponent> partComponent = [];

  @override
  Future<void> onInitialState(SkinEditorState state) async {
    super.onInitialState(state);
    updateParts(state.projectItem);
    gameRef.isDrawable = state.isDrawable;
  }

  @override
  bool listenWhen(SkinEditorState previousState, SkinEditorState newState) {
    if (previousState.isDrawable != newState.isDrawable) {
      isEventIsDrawable = true;
    }

    return isEventIsDrawable;
  }

  @override
  void onNewState(SkinEditorState state) {
    // TODO: implement onNewState
    if (isEventIsDrawable) {
      gameRef.isDrawable = state.isDrawable;
      isEventIsDrawable = false;
    }
    super.onNewState(state);
  }

  void updateParts(ProjectItem? projectItem) {
    if (projectItem != null) {
      Vector2 previousPosition = Vector2.zero();
      for (var i = 0; i < projectItem.parts!.length; i++) {
        final position = _calculatePosition(i, previousPosition);
        final part = PartComponent(
          projectItem.parts![i],
          position: position,
          priority: 50 - i,
        );
        partComponent.add(part);
        previousPosition = position; // Update previousPosition for the next iteration
      }
      addAll(partComponent);
    }
  }

  Vector2 _calculatePosition(int index, Vector2 previousPosition) {
    double x = 0, y = 0;
    // Adjust x and y based on index to match the original pattern
    if (index == 0) {
      x = 0;
      y = 0;
    } else if (index == 1) {
      y = previousPosition.y + 0.21;
    } else if (index >= 2 && index <= 3) {
      y = previousPosition.y + 0.18;
    } else if (index == 4 || index == 7) {
      switch (index) {
        case 4:
          x = -(partComponent[3].position.x + 0.14);
          break;
        case 7:
          x = partComponent[3].position.x + 0.14;
          break;
      }
      y = partComponent[3].position.y + 0.36;
    } else if (index == 5 || index == 8) {
      x = previousPosition.x;
      y = previousPosition.y + 0.24;
    } else if (index == 6 || index == 9) {
      x = previousPosition.x + 0.03;
      y = previousPosition.y + 0.16;
    } else if (index == 10 || index == 12) {
      switch (index) {
        case 10:
          x = -0.3;
          break;
        case 12:
          x = 0.3;
          break;
      }
      y = 0.28;
    } else if (index == 11 || index == 13) {
      x = previousPosition.x + 0.01;
      y = previousPosition.y + 0.26;
    }
    return Vector2(x, y);
  }
}
