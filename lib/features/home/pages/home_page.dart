import 'package:edit_skin_melon/features/home/blocs/home/melon_mods_bloc.dart';
import 'package:edit_skin_melon/features/home/widgets/home/home_list_melon.dart';
import 'package:edit_skin_melon/features/search/blocs/search_bloc.dart';
import 'package:edit_skin_melon/widgets/app_dialog/app_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../search/custom_search_delegate.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
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

              return HomeListMelon(melonList: state.items);
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
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            showSearch(context: context, delegate: CustomSearchDelegate(searchBloc: context.read<SearchBloc>()));
          },
        ),
      ],
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
