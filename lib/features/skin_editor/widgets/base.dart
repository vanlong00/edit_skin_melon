import 'package:edit_skin_melon/features/skin_editor/blocs/skin_editor/skin_editor_bloc.dart';
import 'package:edit_skin_melon/features/skin_editor/widgets/melon_game_widget.dart';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';

import '../models/models.dart';
import 'pi_component.dart';

class Base extends Component with FlameBlocListenable<SkinEditorBloc, SkinEditorState>, HasGameRef<MelonGame> {
  ProjectItem? projectItem;
  bool isEventFirst = false;
  List<PIComponent> partComponent = [];

  @override
  Future<void> onInitialState(SkinEditorState state) async {
    super.onInitialState(state);
    updateParts(state.projectItem);
  }

  @override
  bool listenWhen(SkinEditorState previousState, SkinEditorState newState) {
    // TODO: implement listenWhen
    return previousState.projectItem?.parts?.length != newState.projectItem?.parts?.length;
  }

  @override
  void onNewState(SkinEditorState state) {
    super.onNewState(state);
    updateParts(state.projectItem);
  }

  void updateParts(ProjectItem? projectItem) {
    if (projectItem != null) {
      Vector2 previousPosition = Vector2.zero();
      for (var i = 0; i < projectItem.parts!.length; i++) {
        final position = _calculatePosition(i, previousPosition);
        final part = PIComponent(projectItem.parts![i], position: position);
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
      y = previousPosition.y + 0.17;
    } else if (index == 4) {
      x = -(previousPosition.x + 0.14);
      y = previousPosition.y + 0.36;
    } else if (index == 5) {
      x = previousPosition.x;
      y = previousPosition.y + 0.24;
    } else if (index == 6) {
      x = previousPosition.x + 0.03;
      y = previousPosition.y + 0.146;
    } else if (index == 7) {
      x = partComponent[3].position.x + 0.14;
      y = partComponent[3].position.y + 0.36;
    } else if (index == 8) {
      x = previousPosition.x;
      y = previousPosition.y + 0.24;
    } else if (index == 9) {
      x = previousPosition.x + 0.03;
      y = previousPosition.y + 0.146;
    } else if (index == 10) {
      x = -0.3;
      y = 0.28;
    } else if (index == 11 || index == 13) {
      x = previousPosition.x + 0.01;
      y = previousPosition.y + 0.24;
    } else if (index == 12) {
      x = 0.3;
      y = 0.28;
    }
    return Vector2(x, y);
  }
}
