import 'package:edit_skin_melon/features/home/blocs/home/melon_mods_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    context.read<MelonModsBloc>().add(MelonModsInitialize());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: BlocBuilder<MelonModsBloc, MelonModsState>(
          builder: (context, state) {
            if (state is MelonModsLoading) {
              return _buildLoading();
            }

            if (state is MelonModsComplete) {
              if (state is MelonModsError) {
                return _buildErrors(state);
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
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Center _buildLoading() => const Center(child: CircularProgressIndicator());

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Home Page'),
    );
  }

  Center _buildErrors(MelonModsError state) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(state.failure.code.toString()),
          Text(state.failure.message),
        ],
      ),
    );
  }
}
