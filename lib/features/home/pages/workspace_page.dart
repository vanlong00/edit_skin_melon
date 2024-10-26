import 'package:edit_skin_melon/features/home/blocs/workspace/workspace_bloc.dart';
import 'package:edit_skin_melon/routing/app_route_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../widgets/workspace/workspace_item.dart';

class WorkspacePage extends StatelessWidget {
  const WorkspacePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: BlocBuilder<WorkspaceBloc, WorkspaceState>(
          builder: (context, state) {
            if (state.workSpaceItems.isEmpty) {
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
              itemCount: state.workSpaceItems.length,
              itemBuilder: (context, index) {
                final item = state.workSpaceItems[index];
                return SizedBox(
                  height: index % 3 == 0
                      ? 384
                      : 320, // TODO: Consider making these heights configurable
                  child: WorkspaceItem(item: item),
                );
              },
            );
          },
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Workspace Page'),
      actions: [
        IconButton(
          icon: const Icon(Icons.file_open_rounded),
          onPressed: () {
            Navigator.pushNamed(context, AppRouteName.skinEditor);
          },
        ),
      ],
    );
  }
}
