import 'dart:typed_data';

import 'package:edit_skin_melon/core/utils/helpers/export_game_helper.dart';
import 'package:edit_skin_melon/routing/app_routes.dart';
import 'package:edit_skin_melon/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../blocs/workspace/workspace_bloc.dart';
import '../../models/workspace_model.dart';

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
            alignment: Alignment.bottomRight,
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.communityUpload, arguments: item);
              },
              icon: const Icon(Icons.upload_rounded),
              iconSize: 32, // TODO: Consider making this configurable
            ),
          ),
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