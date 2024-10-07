import 'dart:async';

import 'package:edit_skin_melon/features/skin_editor/blocs/skin_editor/skin_editor_bloc.dart';
import 'package:edit_skin_melon/features/skin_editor/widgets/melon_game_widget.dart';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';

import '../../blocs/skin_part/skin_part_bloc.dart';
import '../../models/models.dart';
import 'part_component.dart';

class FoundationComponent extends Component with HasGameRef<MelonGame> {
  ProjectItem? projectItem;
  bool isEventIsDrawable = false;
  List<PartComponent> partComponent = [];

  @override
  FutureOr<void> onLoad() {
    add(
      FlameBlocListener<SkinEditorBloc, SkinEditorState>(
        onNewState: onNewStateSkinEditor,
        listenWhen: listenWhenSkinEditor,
        onInitialState: onInitialStateSkinEditor,
        bloc: gameRef.skinEditorBloc,
      ),
    );

    add(
      FlameBlocListener<SkinPartBloc, SkinPartState>(
        onNewState: onNewStateSkinPart,
        onInitialState: onInitialStateSkinPart,
        bloc: gameRef.skinPartBloc,
      ),
    );
    return super.onLoad();
  }

  /// ---------------------
  /// Skin Editor
  Future<void> onInitialStateSkinEditor(SkinEditorState state) async {
    gameRef.isDrawable = state.isDrawable;
  }

  bool listenWhenSkinEditor(SkinEditorState previousState, SkinEditorState newState) {
    if (previousState.isDrawable != newState.isDrawable) {
      isEventIsDrawable = true;
    }

    return isEventIsDrawable;
  }

  void onNewStateSkinEditor(SkinEditorState state) {
    if (isEventIsDrawable) {
      gameRef.isDrawable = state.isDrawable;
      isEventIsDrawable = false;
    }
  }

  /// ---------------------
  /// Skin Part
  void onNewStateSkinPart(SkinPartState state) {
    updateParts(state.parts);
  }

  void onInitialStateSkinPart(SkinPartState state) {
    updateParts(state.parts);
  }

  /// ---------------------
  /// Function
  void updateParts(List<Part>? parts) {
    if (partComponent.isNotEmpty) return;

    if (parts != null) {
      Vector2 previousPosition = Vector2.zero();
      for (var i = 0; i < parts.length; i++) {
        final position = _calculatePosition(i, previousPosition);
        final part = PartComponent(
          parts[i],
          position: position,
          index: i,
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
      y = previousPosition.y + 0.22;
    } else if (index == 2) {
      y = previousPosition.y + 0.2;
    } else if (index == 3) {
      y = previousPosition.y + 0.19;
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
