import 'package:edit_skin_melon/features/skin_editor/blocs/skin_editor/skin_editor_bloc.dart';
import 'package:edit_skin_melon/features/skin_editor/blocs/skin_item/skin_item_bloc.dart';
import 'package:edit_skin_melon/features/skin_editor/blocs/skin_part/skin_part_bloc.dart';
import 'package:edit_skin_melon/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class ListSkinWidget extends StatelessWidget {
  const ListSkinWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.white,
      height: 100.h,
      child: BlocBuilder<SkinItemBloc, SkinItemState>(
        builder: (context, state) {
          if (state is SkinItemLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
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
                            context.read<SkinEditorBloc>().add(const SkinEditorSwitchIsDrawableEvent(isDrawable: false));
                            context.read<SkinPartBloc>().add(
                              SkinPartUpdateAvailableModelEvent(
                                skinPath: e,
                                dataPath: state.skinsModel[state.skinsModel.keys.toList()[indexPart]]!["data"]![
                                state.skinsModel[state.skinsModel.keys.toList()[indexPart]]!["thumb"]!
                                    .indexOf(e)],
                                indexPart: indexPart,
                              ),
                            );
                          },
                          child: Container(
                            width: 8.h,
                            height: 8.h,
                            padding: const EdgeInsets.all(2),
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

          return const SizedBox();
        },
      ),
    );
  }
}