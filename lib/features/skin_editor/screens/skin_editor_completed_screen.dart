import 'dart:typed_data';

import 'package:edit_skin_melon/features/skin_editor/utils/constant.dart';
import 'package:edit_skin_melon/features/skin_editor/widgets/animated_size_widget.dart';
import 'package:edit_skin_melon/routing/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:image/image.dart' as img;

import '../blocs/skin_editor/skin_editor_bloc.dart';

class SkinEditorCompletedScreen extends StatelessWidget {
  const SkinEditorCompletedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 12,
          right: 24,
          left: 24,
        ),
        child: Column(
          children: [
            _buildJsonViewerButton(context),
            _buildNameTextField(),
            _buildTypeText(),
            _buildCategoryText(),
            _buildCustomCategoryField(),
            _buildIcon(context),
            _buildSwitchCanBurn(),
            _buildSwitchCanFloat()
          ],
        ),
      ),
    );
  }

  Row _buildSwitchCanBurn() {
    return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('canBurn:'),
              BlocSelector<SkinEditorBloc, SkinEditorState, bool>(
                selector: (state) => state.projectItem?.parts?.first.canBurn ?? false,
                builder: (context, canBurn) {
                  return Switch.adaptive(
                    value: canBurn,
                    onChanged: (value) {
                      context.read<SkinEditorBloc>().add(
                            SkinEditorSwitchAllPartsPropertiesEvent(
                              property: "canBurn",
                              value: value,
                            ),
                          );
                    },
                  );
                },
              ),
            ],
          );
  }

  Row _buildSwitchCanFloat() {
    return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('canFloat:'),
              BlocSelector<SkinEditorBloc, SkinEditorState, bool>(
                selector: (state) => state.projectItem?.parts?.first.canFloat ?? false,
                builder: (context, canFloat) {
                  return Switch.adaptive(
                    value: canFloat,
                    onChanged: (value) {
                      context.read<SkinEditorBloc>().add(
                            SkinEditorSwitchAllPartsPropertiesEvent(
                              property: "canFloat",
                              value: value,
                            ),
                          );
                    },
                  );
                },
              ),
            ],
          );
  }

  Row _buildIcon(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Icon:"),
        BlocSelector<SkinEditorBloc, SkinEditorState, List<int>>(
          selector: (state) => state.projectItem?.icon ?? AppEditorConstant.iconDefault,
          builder: (context, icon) {
            return Container(
              height: 64,
              width: 64,
              color: Colors.black38,
              child: Image.memory(
                Uint8List.fromList(icon),
                filterQuality: FilterQuality.none,
                fit: BoxFit.contain,
              ),
            );
          },
        ),
        TextButton(
          onPressed: () {},
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          child: Text("Change".toUpperCase()),
        )
      ],
    );
  }

  Widget _buildCustomCategoryField() {
    return BlocSelector<SkinEditorBloc, SkinEditorState, (bool, String)>(
      selector: (state) => (state.projectItem?.category == "Custom", state.projectItem?.customCategory ?? ""),
      builder: (context, record) {
        return AnimatedSizeWidget(
          isVisible: record.$1,
          child: Row(
            children: [
              const Text("Custom Category:"),
              const Gap(8),
              Expanded(child: TextFormField()),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryText() {
    return Row(
      children: [
        const Text("Category:"),
        const Gap(8),
        BlocSelector<SkinEditorBloc, SkinEditorState, String>(
          selector: (state) => state.projectItem?.category ?? "Custom",
          builder: (context, state) {
            return DropdownButton<String>(
              value: state,
              items: <String>['Living', 'Custom'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? value) {
                if (value == null) return;
                context.read<SkinEditorBloc>().add(SkinEditorUpdateCategoryEvent(value!));
              },
            );
          },
        ),
      ],
    );
  }

  Row _buildTypeText() {
    return Row(
      children: [
        const Text("Type:"),
        const Gap(8),
        BlocSelector<SkinEditorBloc, SkinEditorState, String>(
          selector: (state) {
            return state.projectItem?.type ?? "";
          },
          builder: (context, type) {
            return Text(type);
          },
        ),
      ],
    );
  }

  Row _buildNameTextField() {
    return Row(
      children: [
        const Text("Name:"),
        const Gap(8),
        Expanded(child: TextFormField()),
      ],
    );
  }

  TextButton _buildJsonViewerButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(
          context,
          AppRoutes.viewJson,
          arguments: context.read<SkinEditorBloc>().state.projectItem?.toMap(),
        );
      },
      style: FilledButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      child: Text("Json viewer".toUpperCase()),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: const Text("Create Skin"),
      centerTitle: true,
    );
  }
}
