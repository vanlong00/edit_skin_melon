import 'dart:async';

import 'package:edit_skin_melon/core/utils/helpers/file_picker_helper.dart';
import 'package:edit_skin_melon/core/utils/helpers/image_picker_helper.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

part 'community_upload_event.dart';
part 'community_upload_state.dart';

@injectable
class CommunityUploadBloc extends Bloc<CommunityUploadEvent, CommunityUploadState> {
  CommunityUploadBloc() : super(const CommunityUploadState()) {
    on<CommunityUploadSelectFileEvent>(_onSelectFile);
    on<CommunityUploadSelectImageOptionEvent>(_onSelectImageOption);
    on<CommunityUploadSelectThumbnailEvent>(_onSelectThumbnail);
  }

  Future<FutureOr<void>> _onSelectImageOption(
      CommunityUploadSelectImageOptionEvent event, Emitter<CommunityUploadState> emit) async {
    final files = await ImagePickerHelper.pickMultipleImageFile(
      maxWidth: 150,
      maxHeight: 150,
    );

    if (files.isNotEmpty) {
      emit(state.copyWith(imagesOption: files));
    }
  }

  Future<void> _onSelectThumbnail(CommunityUploadSelectThumbnailEvent event, Emitter<CommunityUploadState> emit) async {
    final file = await ImagePickerHelper.pickImageFile(
      maxWidth: 150,
      maxHeight: 150,
    );

    if (file != null) {
      emit(state.copyWith(imageThumbnail: XFile(file.path)));
    }
  }

  Future<void> _onSelectFile(CommunityUploadSelectFileEvent event, Emitter<CommunityUploadState> emit) async {
    final file = await FilePickerHelper.pickFile();

    if (file != null) {
      emit(state.copyWith(fileUpload: file));
    }
  }
}
