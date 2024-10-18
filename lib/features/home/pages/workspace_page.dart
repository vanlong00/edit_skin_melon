import 'dart:typed_data';

import 'package:edit_skin_melon/core/utils/helpers/export_game_helper.dart';
import 'package:edit_skin_melon/features/home/blocs/workspace/workspace_bloc.dart';
import 'package:edit_skin_melon/features/home/models/workspace_model.dart';
import 'package:edit_skin_melon/routing/app_routes.dart';
import 'package:edit_skin_melon/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sizer/sizer.dart';

class WorkspacePage extends StatelessWidget {
  const WorkspacePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workspace Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_rounded),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.communityUpload);
            },
          ),
          IconButton(
            icon: const Icon(Icons.file_open_rounded),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.skinEditor);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: BlocBuilder<WorkspaceBloc, WorkspaceState>(
          builder: (context, state) {
            if (state.items.isEmpty) {
              return const Center(
                child: Text('No data'),
              );
            }

            return MasonryGridView.count(
              mainAxisSpacing: 8,
              // TODO: Consider making this configurable
              crossAxisSpacing: 8,
              // TODO: Consider making this configurable
              crossAxisCount: 2,
              // TODO: Consider making this configurable
              itemCount: state.items.length,
              itemBuilder: (context, index) {
                final item = state.items[index];
                return SizedBox(
                  height: index % 3 == 0 ? 448 : 384, // TODO: Consider making these heights configurable
                  child: WorkspaceItem(item: item),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class WorkspaceItem extends StatelessWidget {
  const WorkspaceItem({
    super.key,
    required this.item,
  });

  final WorkspaceModel item;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.backgroundGame,
        borderRadius: BorderRadius.circular(8), // TODO: Consider making this configurable
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _buildImage(),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () {
                context.read<WorkspaceBloc>().add(RemoveWorkspaceEvent(item));
              },
              icon: const Icon(Icons.delete_outline_rounded),
              iconSize: 32, // TODO: Consider making this configurable
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              onPressed: () {
                if (item.locatedAt == null || item.locatedAt!.isEmpty) {
                  return;
                }

                ExportGameHelper.openWith(item.locatedAt!);
              },
              icon: const Icon(Icons.import_export_rounded),
              iconSize: 32, // TODO: Consider making this configurable
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    return Image.memory(
      item.image ?? Uint8List(0),
      width: 100.w,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.none,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) {
          return child;
        }

        return AnimatedOpacity(
          duration: const Duration(milliseconds: 300), // TODO: Consider making this configurable
          opacity: frame == null ? 0 : 1,
          child: child,
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return const Icon(Icons.image);
      },
    );
  }
}
