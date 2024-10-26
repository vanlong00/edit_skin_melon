import 'package:edit_skin_melon/features/home/blocs/community/community_melon_mods_bloc.dart';
import 'package:edit_skin_melon/features/home/widgets/community/community_list_melon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  @override
  void initState() {
    context.read<CommunityMelonModsBloc>().add(CommunityMelonModsInitialize());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: BlocBuilder<CommunityMelonModsBloc, CommunityMelonModsState>(
          builder: (context, state) {
            if (state is CommunityMelonModsLoading) {
              return _buildLoading();
            }

            if (state is CommunityMelonModsComplete) {
              if (state is CommunityMelonModsError) {
                return _buildErrors(state);
              }

              return CommunityListMelon(melonList: state.items);
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
      title: const Text('Community Page'),
    );
  }

  Center _buildErrors(CommunityMelonModsError state) {
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