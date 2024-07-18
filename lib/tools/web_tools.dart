import 'dart:developer';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:edit_skin_melon/core/utils/classes/file_download_helper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../features/skin_editor/models/models.dart';

class WebTools extends StatefulWidget {
  const WebTools({super.key});

  @override
  State<WebTools> createState() => _WebToolsState();
}

class _WebToolsState extends State<WebTools> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  final _defaultFileNameController = TextEditingController();
  final _dialogTitleController = TextEditingController();
  final _initialDirectoryController = TextEditingController();
  final _fileExtensionController = TextEditingController();
  final _indexNamedController = TextEditingController();
  String? _fileName;
  String? _saveAsFileName;
  List<PlatformFile>? _paths;
  List<PlatformFile>? _pathsError;
  String? _directoryPath;
  String? _extension;
  bool _isLoading = false;
  bool _lockParentWindow = false;
  bool _userAborted = false;
  bool _multiPick = true;
  FileType _pickingType = FileType.any;
  double? _exportProgress;

  List<String> typeDirs = [
    'head',
    'body1',
    'body2',
    'body3',
    'leg_left1',
    'leg_left2',
    'leg_left3',
    'leg_right1',
    'leg_right2',
    'leg_right3',
    'arm_left1',
    'arm_left2',
    'arm_right1',
    'arm_right2',
  ];

  @override
  void initState() {
    super.initState();
    _fileExtensionController.addListener(() => _extension = _fileExtensionController.text);
  }

  void _pickFiles() async {
    setState(() {
      _isLoading = true;
      _paths = null;
      _pathsError = null;
      _userAborted = false;
    });
    try {
      // _directoryPath = null;
      _paths = (await FilePicker.platform.pickFiles(
        compressionQuality: 30,
        type: _pickingType,
        allowMultiple: _multiPick,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: (_extension?.isNotEmpty ?? false) ? _extension?.replaceAll(' ', '').split(',') : null,
        dialogTitle: _dialogTitleController.text,
        initialDirectory: _initialDirectoryController.text,
        lockParentWindow: _lockParentWindow,
      ))
          ?.files;
    } on PlatformException catch (e) {
      _logException('Unsupported operation$e');
    } catch (e) {
      _logException(e.toString());
    }
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _fileName = _paths != null ? _paths!.map((e) => e.name).toString() : '...';
      _userAborted = _paths == null;
    });
  }

  Future<void> _exportFolder() async {
    setState(() {
      _isLoading = true;
      _pathsError = null;
      _exportProgress = 0.0; // Reset progress at the start
    });

    try {
      if (_directoryPath == null) {
        throw Exception('Directory path is null');
      }

      _pathsError = [];
      final int indexNamed = int.parse(_indexNamedController.text.isEmpty ? '0' : _indexNamedController.text);
      final total = _paths!.length;
      for (var i = 0; i < total; i++) {
        final fileContent = await File(_paths![i].path!).readAsString();
        final projectItem = ProjectItem.fromJson(fileContent);

        if (projectItem.parts!.length != 14) {
          _pathsError!.add(_paths![i]);
          continue;
        }

        await _exportProjectItemParts(projectItem, i + indexNamed);

        setState(() {
          _exportProgress = (i + 1) / total;
        });
      }
    } on PlatformException catch (e) {
      _logException('Unsupported operation$e');
    } catch (e) {
      _logException(e.toString());
    }
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _exportProgress = null;
    });
  }


  Future<void> _exportProjectItemParts(ProjectItem projectItem, int fileIndex) async {
    for (var index = 0; index < projectItem.parts!.length; index++) {
      final part = projectItem.parts![index];
      final pathFile = "$_directoryPath/${typeDirs[index]}";

      await Future.wait([
        saveImage("$pathFile/thumb/skin$fileIndex.png", part.mainTextureUint8List!),
        saveData("$pathFile/data/skin$fileIndex.json", part.toJson2()),
      ]);
    }
  }

  // Map<String, dynamic> removeSameValue(Map<String, List<dynamic>> originalMap) {
  //   Map<String, dynamic> uniqueValuesMap = {};
  //
  //   for (var type in originalMap.keys.toList()) {
  //     var thumbMap = originalMap[type];
  //
  //     var dataMap = thumbMap!.toSet().toList();
  //
  //     originalMap.update(type, (value) => dataMap);
  //     // var thumbMap2 = Map.fromEntries(dataMap);
  //   }
  //   originalMap.forEach((key, value) {
  //     print(key);
  //     print(value);
  //     print('=====================');
  //   });
  //
  //   return uniqueValuesMap;
  // }

  String _getTypeDir(int index) => typeDirs[index];

  Future<void> saveData(String pathSave, String data) async =>
      FileDownloaderHelper.saveFileAsStringOnDevice(pathSave, data);

  Future<void> saveImage(String pathSave, Uint8List data) =>
      FileDownloaderHelper.saveFileAsByteOnDevice(pathSave, data);

  // void _clearCachedFiles() async {
  //   _resetState();
  //   try {
  //     bool? result = await FilePicker.platform.clearTemporaryFiles();
  //     _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
  //     _scaffoldMessengerKey.currentState?.showSnackBar(
  //       SnackBar(
  //         content: Text(
  //           (result! ? 'Temporary files removed with success.' : 'Failed to clean temporary files'),
  //           style: const TextStyle(
  //             color: Colors.white,
  //           ),
  //         ),
  //       ),
  //     );
  //   } on PlatformException catch (e) {
  //     _logException('Unsupported operation$e');
  //   } catch (e) {
  //     _logException(e.toString());
  //   } finally {
  //     setState(() => _isLoading = false);
  //   }
  // }

  void _selectFolder() async {
    setState(() {
      _isLoading = true;
      _directoryPath = null;
      _userAborted = false;
    });
    try {
      String? path = await FilePicker.platform.getDirectoryPath(
        dialogTitle: _dialogTitleController.text,
        initialDirectory: _initialDirectoryController.text,
        lockParentWindow: _lockParentWindow,
      );
      setState(() {
        _directoryPath = path;
        _userAborted = path == null;
      });
    } on PlatformException catch (e) {
      _logException('Unsupported operation$e');
    } catch (e) {
      _logException(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Future<void> _saveFile() async {
  //   _resetState();
  //   try {
  //     String? fileName = await FilePicker.platform.saveFile(
  //       allowedExtensions: (_extension?.isNotEmpty ?? false) ? _extension?.replaceAll(' ', '').split(',') : null,
  //       type: _pickingType,
  //       dialogTitle: _dialogTitleController.text,
  //       fileName: _defaultFileNameController.text,
  //       initialDirectory: _initialDirectoryController.text,
  //       lockParentWindow: _lockParentWindow,
  //     );
  //     setState(() {
  //       _saveAsFileName = fileName;
  //       _userAborted = fileName == null;
  //     });
  //   } on PlatformException catch (e) {
  //     _logException('Unsupported operation$e');
  //   } catch (e) {
  //     _logException(e.toString());
  //   } finally {
  //     setState(() => _isLoading = false);
  //   }
  // }

  void _logException(String message) {
    log(message);
    _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void _resetState() {
    if (!mounted) {
      return;
    }
    setState(() {
      _isLoading = true;
      // _directoryPath = null;
      _fileName = null;
      _paths = null;
      _pathsError = null;
      _saveAsFileName = null;
      _userAborted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: _scaffoldMessengerKey,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: Colors.deepPurple,
        ),
      ),
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('File Picker example app'),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Configuration',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                buildSizedBox(),
                Wrap(
                  spacing: 10.0,
                  runSpacing: 10.0,
                  children: [
                    SizedBox(
                      width: 400,
                      child: TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Index Named',
                        ),
                        controller: _indexNamedController,
                      ),
                    ),
                    // SizedBox(
                    //   width: 400,
                    //   child: TextField(
                    //     decoration: const InputDecoration(
                    //       border: OutlineInputBorder(),
                    //       labelText: 'Initial Directory',
                    //     ),
                    //     controller: _initialDirectoryController,
                    //   ),
                    // ),
                    // SizedBox(
                    //   width: 400,
                    //   child: TextField(
                    //     decoration: const InputDecoration(
                    //       border: OutlineInputBorder(),
                    //       labelText: 'Default File Name',
                    //     ),
                    //     controller: _defaultFileNameController,
                    //   ),
                    // ),
                    // SizedBox(
                    //   width: 400,
                    //   child: DropdownButtonFormField<FileType>(
                    //     value: _pickingType,
                    //     icon: const Icon(Icons.expand_more),
                    //     alignment: Alignment.centerLeft,
                    //     decoration: const InputDecoration(
                    //       border: OutlineInputBorder(),
                    //     ),
                    //     items: FileType.values
                    //         .map(
                    //           (fileType) => DropdownMenuItem<FileType>(
                    //             child: Text(fileType.toString()),
                    //             value: fileType,
                    //           ),
                    //         )
                    //         .toList(),
                    //     onChanged: (value) => setState(
                    //       () {
                    //         _pickingType = value!;
                    //         if (_pickingType != FileType.custom) {
                    //           _fileExtensionController.text = _extension = '';
                    //         }
                    //       },
                    //     ),
                    //   ),
                    // ),
                    // _pickingType == FileType.custom
                    //     ? SizedBox(
                    //         width: 400,
                    //         child: TextFormField(
                    //           decoration: const InputDecoration(
                    //               border: OutlineInputBorder(), labelText: 'File Extension', hintText: 'jpg, png, gif'),
                    //           autovalidateMode: AutovalidateMode.always,
                    //           controller: _fileExtensionController,
                    //           keyboardType: TextInputType.text,
                    //           maxLength: 15,
                    //         ),
                    //       )
                    //     : const SizedBox(),
                  ],
                ),
                buildSizedBox(),
                Wrap(
                  alignment: WrapAlignment.start,
                  runAlignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  direction: Axis.horizontal,
                  spacing: 10.0,
                  runSpacing: 10.0,
                  children: [
                    SizedBox(
                      width: 400.0,
                      child: SwitchListTile.adaptive(
                        title: const Text(
                          'Lock parent window',
                          textAlign: TextAlign.left,
                        ),
                        onChanged: (bool value) => setState(() => _lockParentWindow = value),
                        value: _lockParentWindow,
                      ),
                    ),
                    ConstrainedBox(
                      constraints: const BoxConstraints.tightFor(width: 400.0),
                      child: SwitchListTile.adaptive(
                        title: const Text(
                          'Pick multiple files',
                          textAlign: TextAlign.left,
                        ),
                        onChanged: (bool value) => setState(() => _multiPick = value),
                        value: _multiPick,
                      ),
                    ),
                  ],
                ),
                buildSizedBox(),
                buildDivider(),
                buildSizedBox(),
                const Text(
                  'Actions',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                  child: Wrap(
                    spacing: 10.0,
                    runSpacing: 10.0,
                    children: <Widget>[
                      SizedBox(
                        width: 120,
                        child: FloatingActionButton.extended(
                            onPressed: () => _pickFiles(),
                            label: Text(_multiPick ? 'Pick files' : 'Pick file'),
                            icon: const Icon(Icons.description)),
                      ),
                      SizedBox(
                        width: 120,
                        child: FloatingActionButton.extended(
                          onPressed: () => _selectFolder(),
                          label: const Text('Pick folder'),
                          icon: const Icon(Icons.folder),
                        ),
                      ),
                      SizedBox(
                        width: 140,
                        child: FloatingActionButton.extended(
                          onPressed: () => _exportFolder(),
                          label: const Text('Export folder'),
                          icon: const Icon(Icons.import_export),
                        ),
                      ),
                      SizedBox(
                        width: 120,
                        child: FloatingActionButton.extended(
                          onPressed: () {},
                          label: const Text('Test'),
                          icon: const Icon(Icons.bug_report),
                        ),
                      ),
                      // SizedBox(
                      //   width: 120,
                      //   child: FloatingActionButton.extended(
                      //     onPressed: () => _saveFile(),
                      //     label: const Text('Save file'),
                      //     icon: const Icon(Icons.save_as),
                      //   ),
                      // ),
                      // SizedBox(
                      //   width: 200,
                      //   child: FloatingActionButton.extended(
                      //     onPressed: () => _clearCachedFiles(),
                      //     label: const Text('Clear temporary files'),
                      //     icon: const Icon(Icons.delete_forever),
                      //   ),
                      // ),
                      // SizedBox(
                      //   width: 120,
                      //   child: FloatingActionButton.extended(
                      //     onPressed: () {
                      //
                      //     },
                      //     label: const Text('Save File'),
                      //     icon: const Icon(Icons.save_as),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                buildDivider(),
                buildSizedBox(),
                if (_directoryPath != null)
                  Column(
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Directory path: ',
                            textAlign: TextAlign.start,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          Text(_directoryPath!),
                        ],
                      ),
                      buildSizedBox(),
                    ],
                  ),
                const Text(
                  'File Picker Result',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Builder(
                  builder: (BuildContext context) => _isLoading
                      ? buildProgressCircle()
                      : _userAborted
                          ? buildError()
                          : buildFiles(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Divider buildDivider() => const Divider();

  SizedBox buildSizedBox() => const SizedBox(height: 20.0);

  Column buildFiles() {
    return Column(
      children: [
        if (_paths != null)
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 20.0,
            ),
            child: Scrollbar(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: _paths != null && _paths!.isNotEmpty ? _paths!.length : 1,
                itemBuilder: (BuildContext context, int index) => _buildItem(context, index, files: _paths),
                separatorBuilder: (BuildContext context, int index) => buildDivider(),
              ),
            ),
          ),
        if (_pathsError != null && _pathsError!.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'File Error',
                textAlign: TextAlign.start,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 20.0,
                ),
                child: Scrollbar(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: _pathsError != null && _pathsError!.isNotEmpty ? _pathsError!.length : 1,
                    itemBuilder: (BuildContext context, int index) => _buildItem(context, index, files: _pathsError),
                    separatorBuilder: (BuildContext context, int index) => buildDivider(),
                  ),
                ),
              ),
            ],
          )
      ],
    );
  }

  Widget? _buildItem(BuildContext context, int index, {List<PlatformFile>? files}) {
    final bool isMultiPath = files != null && files.isNotEmpty;
    final String name = 'File $index: ${isMultiPath ? files.map((e) => e.name).toList()[index] : _fileName ?? '...'}';
    final path = kIsWeb ? null : files!.map((e) => e.path).toList()[index].toString();

    PlatformFile file = files![index];

    return ListTile(
      title: Text("$name  ${file.size} bytes"),
      trailing: Text("${file.size} bytes"),
      subtitle: Text(path ?? ''),
    );
  }

  Row buildError() {
    return const Row(
      children: [
        Expanded(
          child: Center(
            child: SizedBox(
              width: 300,
              child: ListTile(
                leading: Icon(
                  Icons.error_outline,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 40.0),
                title: Text(
                  'User has aborted the dialog',
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildProgressCircle() {
    return const Row(
      children: [
        Expanded(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40.0),
              child: Column(
                children: [
                  CircularProgressIndicator(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
