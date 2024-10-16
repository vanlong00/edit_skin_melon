import 'package:edit_skin_melon/features/home/blocs/workspace/workspace_bloc.dart';
import 'package:edit_skin_melon/routing/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class WorkspacePage extends StatelessWidget {
  const WorkspacePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workspace Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.drive_file_move_sharp),
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

            return SingleChildScrollView(
              child: StaggeredGrid.count(
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                crossAxisCount: 2,
                axisDirection: AxisDirection.down,
                children: [
                  for (final item in state.items)
                    StaggeredGridTile.count(
                      crossAxisCellCount: 1,
                      mainAxisCellCount: 1,
                      child: Container(
                        color: Colors.blue,
                        child: Center(
                          child: Text(item.name ?? ''),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
