import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:edit_skin_melon/core/utils/api_endpoints.dart';
import 'package:edit_skin_melon/core/utils/helpers/file_picker_helper.dart';
import 'package:edit_skin_melon/core/utils/helpers/image_picker_helper.dart';
import 'package:edit_skin_melon/features/home/models/workspace_model.dart';
import 'package:edit_skin_melon/services/api_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

part 'community_upload_event.dart';
part 'community_upload_state.dart';

@injectable
class CommunityUploadBloc extends Bloc<CommunityUploadEvent, CommunityUploadState> {
  final ApiService _apiService;

  CommunityUploadBloc(this._apiService) : super(const CommunityUploadState()) {
    on<CommunityUploadInitEvent>(_onCommunityUploadInitEvent);
    on<CommunityUploadSelectFileEvent>(_onSelectFile);
    on<CommunityUploadSelectImageOptionEvent>(_onSelectImageOption);
    on<CommunityUploadSelectThumbnailEvent>(_onSelectThumbnail);
    on<CommunityUploadSubmitEvent>(_onCommunityUploadSubmitEvent);
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
      emit(state.copyWith(imageThumbnail: await file.readAsBytes()));
    }
  }

  Future<void> _onSelectFile(CommunityUploadSelectFileEvent event, Emitter<CommunityUploadState> emit) async {
    final file = await FilePickerHelper.pickFile();

    if (file != null) {
      emit(state.copyWith(fileUpload: file));
    }
  }

  Future<void> _onCommunityUploadInitEvent(CommunityUploadInitEvent event, Emitter<CommunityUploadState> emit) async {
    if (event.item == null) return;

    emit(
      state.copyWith(
        fileUpload: XFile(event.item!.locatedAt!),
        imageThumbnail: event.item!.image,
      ),
    );
  }

  Future<void> _onCommunityUploadSubmitEvent(
      CommunityUploadSubmitEvent event, Emitter<CommunityUploadState> emit) async {
    try {
      emit(state.copyWith(status: CommunityUploadStatus.submit));
      EasyLoading.show();

      if (!await _canSubmit()) {
        throw Exception('You can only submit once every 5 minutes');
      }

      if (state.fileUpload == null || state.imageThumbnail == null) {
        throw Exception('Please select a file and thumbnail');
      }

      final nameThumbnail = path.basenameWithoutExtension(state.fileUpload!.path);

      List<MultipartFile> files = [];
      if (state.imagesOption != null) {
        for (var file in state.imagesOption!) {
          files.add(await MultipartFile.fromFile(file.path, filename: file.name));
        }
      }

      FormData formData = FormData.fromMap({
        "name": event.name,
        "author": event.author,
        "description": event.description,
        "file": await MultipartFile.fromFile(state.fileUpload!.path, filename: state.fileUpload!.name),
        "thumbnail": MultipartFile.fromBytes(state.imageThumbnail!, filename: '$nameThumbnail.jpg'),
        "images": files,
        "category": 'Living',
        "type": 1,
        "isVerify": false,
        "isLivingSkin": true,
      });

      await _apiService.postRequest(ApiEndpoints.endPointCreateByUser, data: formData);
      await _storeLastSubmissionTime(); // Store the submission time

      emit(state.copyWith(status: CommunityUploadStatus.submitSuccess));
    } catch (e) {
      emit(
        state.copyWith(
          status: CommunityUploadStatus.submitFailed,
          errorMessage: e.toString(),
        ),
      );
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<bool> _canSubmit() async {
    final prefs = await SharedPreferences.getInstance();
    final lastSubmissionTime = prefs.getString('lastSubmissionTime');
    if (lastSubmissionTime == null) {
      return true;
    }
    final lastTime = DateTime.parse(lastSubmissionTime);
    final now = DateTime.now();
    return now.difference(lastTime).inMinutes >= 5;
  }

  Future<void> _storeLastSubmissionTime() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now().toIso8601String();
    await prefs.setString('lastSubmissionTime', now);
  }
}
