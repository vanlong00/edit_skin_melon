import 'dart:async';
import 'package:image/image.dart' as img;

import 'package:edit_skin_melon/features/skin_editor/models/part.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:replay_bloc/replay_bloc.dart';

part 'skin_part_event.dart';

part 'skin_part_state.dart';

@injectable
class SkinPartBloc extends ReplayBloc<SkinPartEvent, SkinPartState> {
  SkinPartBloc() : super(const SkinPartState()) {
    on<SkinPartEventInitialEvent>(_onSkinPartInitialEvent);
    on<SkinPartBlendColorEvent>(_onSkinPartBlendColorEvent);
    on<SkinPartUpdateAvailableModelEvent>(_onSkinPartUpdateAvailableModelEvent);
  }

  FutureOr<void> _onSkinPartInitialEvent(SkinPartEventInitialEvent event, Emitter<SkinPartState> emit) {
    emit(state.copyWith(parts: event.parts));
    clearHistory();
  }

  FutureOr<void> _onSkinPartBlendColorEvent(SkinPartBlendColorEvent event, Emitter<SkinPartState> emit) {
    final partEdited = state.parts?[event.indexPart];

    emit(
      state.copyWith(
        parts: state.parts
            ?.map((part) => part == partEdited ? part.copyWith(mainTextureUint8List: event.data) : part)
            .toList(),
      ),
    );
  }

  Future<FutureOr<void>> _onSkinPartUpdateAvailableModelEvent(
      SkinPartUpdateAvailableModelEvent event, Emitter<SkinPartState> emit) async {
    final skin = await rootBundle.load(event.skinPath).then((value) => value.buffer.asUint8List());
    final data = await rootBundle.loadString(event.dataPath).then((value) => Part.fromJson(value));
    final image = img.decodeImage(skin);

    final partEdited = state.parts?[event.indexPart];

    final newPart = data.copyWith(
      mainTextureUint8List: skin,
      mainTextureWidth: image?.width,
      mainTextureHeight: image?.height,
    );

    emit(
      state.copyWith(
        parts: state.parts?.map((part) => part == partEdited ? newPart : part).toList(),
      ),
    );
  }
}
