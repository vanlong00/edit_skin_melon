import 'dart:async';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:edit_skin_melon/core/utils/helpers/storage_helper.dart';
import 'package:edit_skin_melon/services/download_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as path;

part 'detail_event.dart';
part 'detail_state.dart';

@injectable
class DetailBloc extends Bloc<DetailEvent, DetailState> {
  final DownloadService _downloadService;

  DetailBloc(this._downloadService) : super(DetailInitial()) {
    on<DetailStartedDownload>(_onDetailStartedDownload, transformer: droppable());
  }

  FutureOr<void> _onDetailStartedDownload(DetailStartedDownload event, Emitter<DetailState> emit) async {
    emit(DetailDownloadLoading());
    String? extractTo;
    try {
      EasyLoading.show();

      final fileName = _validateAndExtractFileName(event.linkDownload);
      final filePath = await _prepareFilePath(fileName);

      // Create Extraction Directory
      if (_isFileZip(filePath)) {
        await _downloadService.downloadFile(event.linkDownload!, filePath);

        await _extractZipFile(filePath);
      } else {
        extractTo = path.join(path.dirname(filePath), path.basenameWithoutExtension(filePath));
        await Directory(extractTo).create(recursive: true);

        await _downloadService.downloadFile(event.linkDownload!, path.join(extractTo, fileName));
      }

      emit(DetailDownloadSuccess());
    } catch (e) {
      emit(DetailDownloadFailure(e.toString()));
    } finally {
      EasyLoading.dismiss();
    }
  }

  bool _isFileZip(String filePath) => filePath.endsWith('.zip');

  Future<void> _extractZipFile(String filePath) async {
    try {
      // Read File Bytes & Decode ZIP Archive
      final bytes = await File(filePath).readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);

      // Create Extraction Directory
      final extractTo = path.join(path.dirname(filePath), path.basenameWithoutExtension(filePath));
      await Directory(extractTo).create(recursive: true);

      // Extract Files
      for (final file in archive) {
        final fileName = path.join(extractTo, file.name);
        if (file.isFile) {
          await File(fileName).create(recursive: true);
          await File(fileName).writeAsBytes(file.content as List<int>);
        } else {
          await Directory(fileName).create(recursive: true);
        }
      }
    } catch (e) {
      dev.log('Error extracting ZIP file: $e');
      throw Exception('Failed to extract ZIP file: $e');
    } finally {
      // Delete ZIP File
      await File(filePath).delete();
    }
  }

  String _validateAndExtractFileName(String? linkDownload) {
    if (linkDownload == null) {
      throw Exception('Link download is not available');
    }
    return path.basename(linkDownload);
  }

  Future<String> _prepareFilePath(String fileName) async {
    final directory = await StorageHelper.getSavedDirectory();
    final directoryMods = Directory(path.join(directory.path, 'Mods'));
    if (!directoryMods.existsSync()) {
      directoryMods.createSync();
    }
    return path.join(directoryMods.path, fileName);
  }
}
