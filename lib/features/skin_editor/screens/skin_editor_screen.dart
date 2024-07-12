import 'package:edit_skin_melon/features/skin_editor/blocs/skin_editor/skin_editor_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../widgets/view_game_widget.dart';

class SkinEditorScreen extends StatefulWidget {
  const SkinEditorScreen({super.key});

  @override
  State<SkinEditorScreen> createState() => _SkinEditorScreenState();
}

class _SkinEditorScreenState extends State<SkinEditorScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SkinEditorBloc>().add(const SkinEditorInitialEvent("assets/textures/Untitled.melmod"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Row(
        children: [
          const Expanded(child: ViewGameWidget()),
          SizedBox(
            width: 25.w,
            child: Center(
              child: IconButton(
                icon: const Icon(Icons.add, size: 64),
                onPressed: () async {

                },
              ),
            ),
          )
        ],
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text("Skin Editor"),
      actions: [
        IconButton(
          icon: const Icon(Icons.code),
          onPressed: () {
            Navigator.pushNamed(context, "/view_json");
          },
        )
      ],
    );
  }
}
