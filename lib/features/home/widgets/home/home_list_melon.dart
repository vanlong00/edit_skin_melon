import 'package:edit_skin_melon/features/home/blocs/home/melon_mods_bloc.dart';
import 'package:edit_skin_melon/features/home/models/melon_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class HomeListMelon extends StatefulWidget {
  final List<dynamic> melonList;

  const HomeListMelon({super.key, required this.melonList});

  @override
  State<HomeListMelon> createState() => _HomeListMelonState();
}

class _HomeListMelonState extends State<HomeListMelon> {
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return BlocListener<MelonModsBloc, MelonModsState>(
      listener: (context, state) async {
        if (state is MelonModsLoadMoreComplete) {
          _refreshController.loadComplete();
        } else if (state is MelonModsLoadNoMoreData) {
          _refreshController.loadNoData();
        } else if (state is MelonModsLoadMoreError) {
          _refreshController.loadFailed();
        } else if (state is MelonModsRefreshComplete) {
          _refreshController.refreshCompleted();
        } else if (state is MelonMOdsRefreshError) {
          _refreshController.refreshFailed();
        }
      },
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: widget.melonList.isNotEmpty,
        physics: const ClampingScrollPhysics(),
        header: const MaterialClassicHeader(),
        footer: CustomFooter(
          builder: (context, mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = const Text("Pull up load");
            } else if (mode == LoadStatus.loading) {
              body = const CircularProgressIndicator();
            } else if (mode == LoadStatus.failed) {
              body = const Text("Load Failed!Click retry!");
            } else if (mode == LoadStatus.canLoading) {
              body = const Text("Release to load more");
            } else {
              body = const Text("No more Data");
            }
            return Container(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: StaggeredGrid.count(
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          crossAxisCount: 2,
          children: [
            for (final item in widget.melonList)
              StaggeredGridTile.count(
                crossAxisCellCount: 1,
                mainAxisCellCount: 1,
                child: ItemModWidget(item: item),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _onLoading() async {
    context.read<MelonModsBloc>().add(MelonModsLoadMore());
  }

  Future<void> _onRefresh() async {
    context.read<MelonModsBloc>().add(MelonModsRefresh());
  }
}

class ItemModWidget extends StatelessWidget {
  const ItemModWidget({
    super.key,
    required this.item,
  });

  final MelonModel item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          const Spacer(),
          Text(item.name ?? ''),
        ],
      ),
    );
  }
}
