import 'package:edit_skin_melon/features/skin_editor/blocs/skin_editor/skin_editor_bloc.dart';
import 'package:edit_skin_melon/features/skin_editor/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_view/json_view.dart';

class ViewJsonScreen extends StatelessWidget {
  const ViewJsonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Skin Editor"),
      ),
      body: BlocSelector<SkinEditorBloc, SkinEditorState, ProjectItem?>(
        selector: (SkinEditorState state) => state.projectItem,
        builder: (context, state) {
          return JsonView(
            json: state?.toMap(),
          );
        },
      ),
    );
  }
}
