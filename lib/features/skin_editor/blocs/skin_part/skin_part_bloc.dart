import 'dart:async';
import 'dart:typed_data';

import 'package:edit_skin_melon/features/skin_editor/models/part.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:replay_bloc/replay_bloc.dart';

part 'skin_part_event.dart';

part 'skin_part_state.dart';

@injectable
class SkinPartBloc extends ReplayBloc<SkinPartEvent, SkinPartState> {
  SkinPartBloc() : super(const SkinPartState()) {
    on<SkinPartEventInitialEvent>(_onSkinPartInitialEvent);
    on<SkinPartBlendColorEvent>(_onSkinPartBlendColorEvent);
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
}
