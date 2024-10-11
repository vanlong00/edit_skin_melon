import 'dart:typed_data';

import 'package:edit_skin_melon/core/utils/helpers/image_picker_helper.dart';
import 'package:edit_skin_melon/features/home/bloc/workspace/workspace_bloc.dart';
import 'package:edit_skin_melon/features/skin_editor/utils/constant.dart';
import 'package:edit_skin_melon/features/skin_editor/widgets/animated_size_widget.dart';
import 'package:edit_skin_melon/routing/app_routes.dart';
import 'package:edit_skin_melon/widgets/app_text_field_widget/app_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../blocs/skin_editor/skin_editor_bloc.dart';

class SkinEditorCompletedScreen extends StatefulWidget {
  const SkinEditorCompletedScreen({super.key});

  @override
  State<SkinEditorCompletedScreen> createState() => _SkinEditorCompletedScreenState();
}

class _SkinEditorCompletedScreenState extends State<SkinEditorCompletedScreen> {
  final GlobalKey<AppTextFieldWidgetState> _keyName = GlobalKey();
  final GlobalKey<AppTextFieldWidgetState> _keyCategoryCustom = GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  late BuildContext context;

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      appBar: buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 12,
          right: 24,
          left: 24,
        ),
        child: BlocListener<SkinEditorBloc, SkinEditorState>(
          listener: (context, state) {
            if (state.status == SkinEditorStatusState.complete) {
              Navigator.popUntil(context, (route) => route.settings.name == AppRoutes.home);
            }
          },
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildJsonViewerButton(),
                _buildNameTextField(),
                _buildTypeText(),
                _buildCategoryText(),
                _buildCustomCategoryField(),
                _buildIcon(),
                _buildSwitchCanBurn(),
                _buildSwitchCanFloat()
              ],
            ),
          ),
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

  Row _buildIcon() {
    return Row(
      children: [
        const Text("Icon:"),
        const Spacer(),
        TextButton(
          onPressed: () async {
            Uint8List? icon = await ImagePickerHelper.pickImageBytes();

            if (!context.mounted) return;
            context.read<SkinEditorBloc>().add(SkinEditorChangeIconEvent(icon));
          },
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          child: Text("Change".toUpperCase()),
        ),
        const Gap(8),
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
      ],
    );
  }

  Widget _buildCustomCategoryField() {
    return BlocSelector<SkinEditorBloc, SkinEditorState, (bool, String)>(
      selector: (state) => (state.projectItem?.category == "Custom", state.projectItem?.customCategory ?? ""),
      builder: (context, record) {
        return AnimatedSizeWidget(
          isVisible: record.$1,
          child: AppTextFieldWidget.string(
            key: _keyCategoryCustom,
            validator: (value) {
              return null;
            },
            label: "Category Custom:",
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
                context.read<SkinEditorBloc>().add(SkinEditorUpdateCategoryEvent(value));
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
          selector: (state) => state.projectItem?.type ?? "",
          builder: (_, type) => Text(type),
        ),
      ],
    );
  }

  Widget _buildNameTextField() {
    return AppTextFieldWidget.string(
      key: _keyName,
      label: "Name:",
    );
  }

  TextButton _buildJsonViewerButton() {
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
      actions: [
        IconButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) {
              return;
            }
            String name = _keyName.currentState!.value;
            String categoryCustomName = _keyCategoryCustom.currentState!.value;

            print("Name: $name");
            print("Category Custom: $categoryCustomName");

            context.read<SkinEditorBloc>().add(
                  SkinEditorSaveEvent(
                    name: name,
                    categoryCustom: categoryCustomName,
                  ),
                );
          },
          icon: const Icon(Icons.save),
        ),
      ],
    );
  }
}
