import 'package:edit_skin_melon/features/skin_editor/blocs/skin_editor/skin_editor_bloc.dart';
import 'package:edit_skin_melon/features/skin_editor/blocs/skin_item/skin_item_bloc.dart';
import 'package:edit_skin_melon/features/skin_editor/blocs/skin_part/skin_part_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    context.read<SkinEditorBloc>().add(SkinEditorInitialEvent("assets/textures/default.melmod", context: context));
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
      body: Stack(
        children: [
          const ViewGameWidget(),
          Column(
            children: [
              _buildColorPalette(),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: 10.w,
                  width: 10.w,
                  child: Icon(
                    Icons.palette,
                    color: Theme.of(context).colorScheme.primary,
                    size: 8.w,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  BlocSelector<SkinEditorBloc, SkinEditorState, (bool, Color)> _buildColorPalette() {
    return BlocSelector<SkinEditorBloc, SkinEditorState, (bool, Color)>(
      selector: (state) => (state.isDrawable, state.colorDraw),
      builder: (context, record) {
        return AnimatedSize(
          duration: const Duration(seconds: 1),
          reverseDuration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
          child: SizedBox(
            height: record.$1 ? 12.w : 0.w,
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
                        height: 8.w,
                        width: 8.w,
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
        BlocSelector<SkinEditorBloc, SkinEditorState, bool>(
          selector: (state) => state.isShowGrid,
          builder: (context, isShowGrid) {
            return IconButton(
              onPressed: () {
                context.read<SkinEditorBloc>().add(const SkinEditorSwitchIsShowGridEvent());
              },
              isSelected: isShowGrid,
              icon: const Icon(Icons.grid_off_outlined),
              selectedIcon: const Icon(Icons.grid_on),
            );
          },
        ),
        BlocBuilder<SkinPartBloc, SkinPartState>(
          builder: (context, state) {
            final bloc = context.read<SkinPartBloc>();

            return IconButton(
              onPressed: bloc.canUndo ? bloc.undo : null,
              icon: const Icon(Icons.undo),
            );
          },
        ),
        BlocBuilder<SkinPartBloc, SkinPartState>(
          builder: (context, state) {
            final bloc = context.read<SkinPartBloc>();

            return IconButton(
              onPressed: bloc.canRedo ? bloc.redo : null,
              icon: const Icon(Icons.redo),
            );
          },
        ),
        // IconButton(
        //   onPressed: () {
        //     Navigator.pushNamed(context, "/view_json");
        //   },
        //   icon: const Icon(Icons.code),
        // ),
        IconButton(
          onPressed: () {
            List<(String, List<int>)> items = [
              ("head", [0]),
              ("body1", [1]),
              ("body2", [2]),
              ("body3", [3]),
              ("leg1", [4, 7]),
              ("leg2", [5, 8]),
              ("leg3", [6, 9]),
              ("arm1", [10, 12]),
              ("arm2", [11, 13]),
            ];

            showModalBottomSheet(
              context: context,
              showDragHandle: true,
              isScrollControlled: true,
              builder: (BuildContext _) {
                return BlocProvider.value(
                  value: context.read<SkinEditorBloc>(),
                  child: SizedBox(
                    height: 30.h,
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                        childAspectRatio: 4.0,
                      ),
                      itemCount: items.length,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
                      itemBuilder: (__, index) {
                        var item = items[index];
                        return BlocSelector<SkinEditorBloc, SkinEditorState, bool>(
                          selector: (state) => item.$2.every((element) => state.isShowPart[element]),
                          builder: (context, isSelected) {
                            return GestureDetector(
                              onTap: () => context.read<SkinEditorBloc>().add(SkinEditorIsShowPartEvent(item.$2)),
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color:
                                      isSelected ? Theme.of(context).colorScheme.primaryContainer : Colors.transparent,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                padding: const EdgeInsets.all(8.0),
                                margin: const EdgeInsets.symmetric(vertical: 4.0),
                                child: Text(
                                  item.$1,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                );
              },
            );
          },
          icon: const Icon(Icons.remove_red_eye_outlined),
        ),
      ],
    );
  }
}
