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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: SafeArea(
        child: Stack(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 75.w,
                  child: const ViewGameWidget(),
                ),
                Container(
                  color: Colors.amberAccent,
                  width: 25.w,
                  height: 100.h,
                  child: BlocBuilder<SkinItemBloc, SkinItemState>(
                    builder: (context, state) {
                      if (state is SkinItemLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state is SkinItemLoaded) {
                        return SingleChildScrollView(
                          child: BlocSelector<SkinItemBloc, SkinItemState, int>(
                            selector: (state) => state is SkinItemLoaded ? state.indexPart : 0,
                            builder: (context, indexPart) {
                              return Column(
                                children: [
                                  Text(state.skinsModel.keys.toList()[indexPart]),
                                  ...state.skinsModel[state.skinsModel.keys.toList()[indexPart]]!["thumb"]!.map((e) {
                                    return GestureDetector(
                                      onTap: () {
                                        context.read<SkinEditorBloc>().add(
                                          SkinEditorUpdateAvailableModelEvent(
                                            skinPath: e,
                                            dataPath:
                                            state.skinsModel[state.skinsModel.keys.toList()[indexPart]]!["data"]![
                                            state.skinsModel[state.skinsModel.keys.toList()[indexPart]]!["thumb"]!
                                                .indexOf(e)],
                                            indexPart: indexPart,
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width: 10.h,
                                        height: 10.h,
                                        padding: EdgeInsets.all(1.w),
                                        decoration: BoxDecoration(
                                          color: AppColor.backgroundGame,
                                          border: Border.all(color: Colors.black),
                                        ),
                                        child: Image.asset(
                                          e,
                                          filterQuality: FilterQuality.none,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ],
                              );
                            },
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text("Skin Editor"),
      actions: [
        BlocSelector<SkinEditorBloc, SkinEditorState, bool>(
          selector: (state) {
            return getIt<SkinEditorBloc>().canUndo;
          },
          builder: (context, canUndo) {
            return IconButton(
              onPressed: canUndo ? getIt<SkinEditorBloc>().undo : null,
              icon: const Icon(Icons.undo),
            );
          },
        ),
        BlocSelector<SkinEditorBloc, SkinEditorState, bool>(
          selector: (state) {
            return getIt<SkinEditorBloc>().canRedo;
          },
          builder: (context, canRedo) {
            return IconButton(
              onPressed: canRedo ? getIt<SkinEditorBloc>().redo : null,
              icon: const Icon(Icons.redo),
            );
          },
        ),
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
