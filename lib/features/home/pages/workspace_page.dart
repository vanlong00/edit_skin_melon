import 'package:edit_skin_melon/features/home/blocs/workspace/workspace_bloc.dart';
import 'package:edit_skin_melon/routing/app_route_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
              return _buildEmptyWidget();
            }

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 9 / 16,
              ),
              itemCount: state.workSpaceItems.length,
              itemBuilder: (context, index) {
                final item = state.workSpaceItems[index];
                return WorkspaceItem(item: item);
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

  Widget _buildEmptyWidget() {
    return const Center(
      child: Text(
        'No items available',
        style: TextStyle(fontSize: 18, color: Colors.grey),
      ),
    );
  }
}
