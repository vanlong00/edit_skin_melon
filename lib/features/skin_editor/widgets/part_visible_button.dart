import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../blocs/skin_editor/skin_editor_bloc.dart';

class PartVisibleButton extends StatelessWidget {
  const PartVisibleButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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

    return IconButton(
      onPressed: () {
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
                              color: isSelected ? Theme.of(context).colorScheme.primaryContainer : Colors.white,
                              borderRadius: BorderRadius.circular(8),
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
    );
  }
}
