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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: buildAppBar(context),
        body: Stack(
          children: [
            const ViewGameWidget(),
            BlocSelector<SkinEditorBloc, SkinEditorState, (bool, Color)>(
              selector: (state) => (state.isDrawable, state.colorDraw),
              builder: (context, record) {
                return Visibility(
                  visible: record.$1,
                  child: Container(
                    width: 100.w,
                    margin: EdgeInsets.symmetric(horizontal: 2.w),
                    padding: EdgeInsets.all(1.w),
                    child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 8,
                        crossAxisSpacing: 1.w,
                        mainAxisSpacing: 1.w,
                      ),
                      itemCount: colorPalette.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            context.read<SkinEditorBloc>().add(SkinEditorPickColorEvent(colorPalette[index]));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: colorPalette[index],
                              border: record.$2 == colorPalette[index]
                                  ? Border.all(
                                      color: getTextColor(colorPalette[index]),
                                      width: 2,
                                      strokeAlign: BorderSide.strokeAlignInside,
                                      style: BorderStyle.solid,
                                    )
                                  : null,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
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

  Color getTextColor(Color color) {
    int d = 0;

    // Counting the perceptive luminance - human eye favors green color...
    double luminance = (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;

    if (luminance > 0.5) {
      d = 0; // bright colors - black font
    } else {
      d = 255; // dark colors - white font
    }

    return Color.fromARGB(color.alpha, d, d, d);
  }
}
