import 'package:edit_skin_melon/features/home/widgets/melon_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../blocs/workspace/workspace_bloc.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: BlocBuilder<WorkspaceBloc, WorkspaceState>(
          builder: (context, state) {
            if (state.melonItems.isEmpty) {
              return _buildEmptyWidget();
            }

            return MasonryGridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              itemCount: state.melonItems.length,
              itemBuilder: (context, index) {
                final item = state.melonItems[index];
                return MelonWidget.home(item: item);
              },
            );
          },
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('History Page'),
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
