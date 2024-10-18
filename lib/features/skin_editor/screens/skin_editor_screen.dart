import 'package:edit_skin_melon/features/skin_editor/blocs/skin_editor/skin_editor_bloc.dart';
import 'package:edit_skin_melon/features/skin_editor/blocs/skin_item/skin_item_bloc.dart';
import 'package:edit_skin_melon/features/skin_editor/blocs/skin_part/skin_part_bloc.dart';
import 'package:edit_skin_melon/routing/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../widgets/animated_size_widget.dart';
import '../widgets/list_skin_widget.dart';
import '../widgets/part_visible_button.dart';
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
    context
        .read<SkinEditorBloc>()
        .add(SkinEditorInitialEvent("assets/textures/melontemplate.melmod", context: context));
    context.read<SkinItemBloc>().add(SkinItemInitData());
  }

  List<Color> colorPalette = [
    Colors.black,
    Colors.white,
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.brown,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: _buildGameWidget(context),
    );
  }

  Stack _buildGameWidget(BuildContext context) {
    return Stack(
      children: [
        const ViewGameWidget(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      const PartVisibleButton(),
                      _buildGridButton(),
                      _buildButtonDraw(),
                      _buildColorPalette(context),
                      const Spacer(),
                      _buildUndoButton(),
                      _buildRedoButton(),
                    ],
                  ),
                ],
              ),
            ),
            const ListSkinWidget()
          ],
        ),
      ],
    );
  }

  BlocSelector<SkinEditorBloc, SkinEditorState, (bool, Color)> _buildColorPalette(BuildContext context) {
    return BlocSelector<SkinEditorBloc, SkinEditorState, (bool, Color)>(
      selector: (state) => (state.isDrawable, state.colorDraw),
      builder: (_, record) {
        return AnimatedSizeWidget(
          isVisible: record.$1,
          duration: const Duration(milliseconds: 100),
          child: IconButton(
            onPressed: () => showDialogColor(context, record.$2),
            icon: const Icon(Icons.palette_outlined),
          ),
        );
      },
    );
  }

  Future<dynamic> showDialogColor(BuildContext context, Color pickerColor) {
    return showDialog(
      context: context,
      builder: (__) {
        final SkinEditorBloc bloc = context.read<SkinEditorBloc>();
        return BlocProvider.value(
          value: bloc,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AlertDialog(
                  title: const Text('Pick a color!'),
                  content: ColorPicker(
                    pickerColor: pickerColor,
                    onColorChanged: (value) {
                      bloc.add(SkinEditorPickColorEvent(value));
                    },
                    colorHistory: bloc.state.historyColorDraw,
                    enableAlpha: false,
                    pickerAreaBorderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text("Skin Editor"),
      actions: [
        IconButton(
          onPressed: () async {
            context.read<SkinEditorBloc>().add(SkinEditorUpdatePartEvent(
                  context.read<SkinPartBloc>().state.parts ?? [],
                  context: context,
                ));

            if (!context.mounted) return;
            Navigator.pushNamed(
              context,
              AppRoutes.skinEditorCompleted,
              arguments: context.read<SkinEditorBloc>(),
            );
          },
          icon: const Icon(Icons.navigate_next_outlined),
        ),
      ],
    );
  }

  BlocSelector<SkinEditorBloc, SkinEditorState, bool> _buildButtonDraw() {
    return BlocSelector<SkinEditorBloc, SkinEditorState, bool>(
      selector: (state) => state.isDrawable,
      builder: (context, isDrawable) {
        return IconButton(
          onPressed: () {
            context.read<SkinEditorBloc>().add(const SkinEditorSwitchIsDrawableEvent());
          },
          isSelected: isDrawable,
          icon: const Icon(Icons.draw_outlined),
          selectedIcon: const Icon(Icons.draw),
        );
      },
    );
  }

  BlocSelector<SkinEditorBloc, SkinEditorState, bool> _buildGridButton() {
    return BlocSelector<SkinEditorBloc, SkinEditorState, bool>(
      selector: (state) => state.isShowGrid,
      builder: (context, isShowGrid) {
        return IconButton(
          onPressed: () {
            context.read<SkinEditorBloc>().add(const SkinEditorSwitchIsShowGridEvent());
          },
          icon: isShowGrid ? const Icon(Icons.grid_off_outlined) : const Icon(Icons.grid_on_outlined),
        );
      },
    );
  }

  BlocBuilder<SkinPartBloc, SkinPartState> _buildUndoButton() {
    return BlocBuilder<SkinPartBloc, SkinPartState>(
      builder: (context, state) {
        final bloc = context.read<SkinPartBloc>();

        return IconButton(
          onPressed: bloc.canUndo ? bloc.undo : null,
          icon: const Icon(Icons.undo),
        );
      },
    );
  }

  BlocBuilder<SkinPartBloc, SkinPartState> _buildRedoButton() {
    return BlocBuilder<SkinPartBloc, SkinPartState>(
      builder: (context, state) {
        final bloc = context.read<SkinPartBloc>();

        return IconButton(
          onPressed: bloc.canRedo ? bloc.redo : null,
          icon: const Icon(Icons.redo),
        );
      },
    );
  }
}
