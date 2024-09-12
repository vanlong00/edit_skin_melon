import 'package:edit_skin_melon/features/skin_editor/blocs/skin_editor/skin_editor_bloc.dart';
import 'package:edit_skin_melon/features/skin_editor/blocs/skin_item/skin_item_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../core/di/di.dart';
import '../../../theme/app_color.dart';
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
    context.read<SkinEditorBloc>().add(const SkinEditorInitialEvent("assets/textures/default.melmod"));
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

  List<String> imagePart = [
    "assets/images/head1.png",
    "assets/images/body1.png",
    "assets/images/body2.png",
    "assets/images/body3.png",
    "assets/images/leg1.png",
    "assets/images/leg2.png",
    "assets/images/leg3.png",
    "assets/images/arm1.png",
    "assets/images/arm2.png",
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: buildAppBar(context),
        body: Stack(
          children: [
            const ViewGameWidget(),
            _buildColorPalette(),
          ],
        ),
      ),
    );
  }

  BlocSelector<SkinEditorBloc, SkinEditorState, (bool, Color)> _buildColorPalette() {
    return BlocSelector<SkinEditorBloc, SkinEditorState, (bool, Color)>(
      selector: (state) => (state.isDrawable, state.colorDraw),
      builder: (context, record) {
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: record.$1 ? 1.0 : 0.0,
          curve: Curves.easeInOut,
          child: IgnorePointer(
            ignoring: !record.$1,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(vertical: 2.w),
              child: Row(
                children: colorPalette.map((color) {
                  return GestureDetector(
                    onTap: () {
                      context.read<SkinEditorBloc>().add(SkinEditorPickColorEvent(color));
                    },
                    child: AnimatedScale(
                      scale: record.$2 == color ? 1.2 : 1,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 1.w),
                        height: 12.w,
                        width: 12.w,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text("Skin Editor"),
      automaticallyImplyLeading: false,
      actions: [
        BlocSelector<SkinEditorBloc, SkinEditorState, bool>(
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
        ),
        // BlocSelector<SkinEditorBloc, SkinEditorState, bool>(
        //   selector: (state) {
        //     return getIt<SkinEditorBloc>().canUndo;
        //   },
        //   builder: (context, canUndo) {
        //     return IconButton(
        //       onPressed: canUndo ? getIt<SkinEditorBloc>().undo : null,
        //       icon: const Icon(Icons.undo),
        //     );
        //   },
        // ),
        // BlocSelector<SkinEditorBloc, SkinEditorState, bool>(
        //   selector: (state) {
        //     return getIt<SkinEditorBloc>().canRedo;
        //   },
        //   builder: (context, canRedo) {
        //     return IconButton(
        //       onPressed: canRedo ? getIt<SkinEditorBloc>().redo : null,
        //       icon: const Icon(Icons.redo),
        //     );
        //   },
        // ),
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, "/view_json");
          },
          icon: const Icon(Icons.code),
        )
      ],
    );
  }
}
