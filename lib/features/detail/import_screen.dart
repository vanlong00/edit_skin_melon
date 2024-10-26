import 'dart:developer';
import 'dart:io';

import 'package:edit_skin_melon/core/utils/helpers/export_game_helper.dart';
import 'package:edit_skin_melon/core/utils/helpers/storage_helper.dart';
import 'package:edit_skin_melon/features/home/models/melon_model.dart';
import 'package:edit_skin_melon/features/skin_editor/models/models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

class ImportScreen extends StatefulWidget {
  final MelonModel melonModel;

  const ImportScreen({super.key, required this.melonModel});

  @override
  State<ImportScreen> createState() => _ImportScreenState();
}

class _ImportScreenState extends State<ImportScreen> {
  Future<List<String>> _getImportData() async {
    List<String> importedFiles = [];
    try {
      final fileUrl = widget.melonModel.fileUrl;
      if (fileUrl == null) {
        throw Exception('File URL is null');
      }

      final storage = await StorageHelper.getSavedDirectory();
      final directoryPath = path.join(storage.path, 'Mods', path.basenameWithoutExtension(fileUrl));
      final directory = Directory(directoryPath);

      if (!directory.existsSync()) {
        throw Exception('Directory does not exist');
      }

      await for (var file in directory.list()) {
        if (file is File) importedFiles.add(file.path);
      }
    } catch (e) {
      // Handle the error appropriately
    }
    return importedFiles;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.melonModel.name ?? ''),
      ),
      body: FutureBuilder<List<String>>(
        future: _getImportData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final importedFiles = snapshot.data as List<String>;
          if (importedFiles.isEmpty) {
            return const Center(child: Text('No files found'));
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
            itemCount: importedFiles.length,
            itemBuilder: (context, index) {
              final file = importedFiles[index];
              return ImportItemWidget(pathItem: file);
            },
          );
        },
      ),
    );
  }
}

class ImportItemWidget extends StatelessWidget {
  final String pathItem;

  const ImportItemWidget({super.key, required this.pathItem});

  bool get isMelsave => path.extension(pathItem) == '.melsave';

  Future<String> _readFileContents(String filePath) async {
    final file = File(filePath);
    return file.readAsStringSync();
  }

  Future<ProjectItem?> readFilePath() async {
    try {
      // Check if the file exists
      final file = File(pathItem);
      if (await file.exists()) {
        // Read the file
        String contents = await compute(_readFileContents, pathItem);

        ProjectItem projectItem = ProjectItem.fromJson(contents);
        return projectItem;
      } else {
        log('File does not exist');
      }
    } catch (e) {
      log('Error reading file: ${e.toString()}');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildIcon(),
        ElevatedButton(
          onPressed: () {
            // Import the file
            ExportGameHelper.openWith(pathItem);
          },
          child: const Text('Import'),
        ),
      ],
    );
  }

  Container _buildIcon() {
    return Container(
      width: 128,
      height: 128,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: isMelsave
          ? const Icon(Icons.save_rounded, size: 32)
          : FutureBuilder<ProjectItem?>(
              future: readFilePath(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildIconLoading();
                }

                if (snapshot.hasError) {
                  return _buildIconError();
                }

                final projectItem = snapshot.data;
                if (projectItem == null) {
                  return _buildIconError();
                }

                return Image.memory(
                  Uint8List.fromList(projectItem.icon ?? []),
                  filterQuality: FilterQuality.none,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildIconError();
                  },
                );
              },
            ),
    );
  }

  Icon _buildIconError() => const Icon(Icons.error_rounded, size: 32);

  Center _buildIconLoading() => const Center(child: CircularProgressIndicator());
}
