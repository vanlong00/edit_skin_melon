import 'dart:math';

import 'package:edit_skin_melon/features/detail/widgets/read_more_widget.dart';
import 'package:edit_skin_melon/features/home/blocs/home/melon_mods_bloc.dart';
import 'package:edit_skin_melon/features/home/blocs/workspace/workspace_bloc.dart';
import 'package:edit_skin_melon/features/home/models/melon_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/app_image_network_widget.dart';
import '../home/widgets/melon_widget.dart';
import 'blocs/detail_bloc.dart';
import 'widgets/detail_button_widget.dart';

class DetailScreen extends StatefulWidget {
  final MelonModel melonModel;

  const DetailScreen({super.key, required this.melonModel});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  void handleListenableDetailBloc(BuildContext context, DetailState state) {
    if (state is DetailDownloadSuccess) {
      context.read<WorkspaceBloc>().add(AddMelonEvent(widget.melonModel));
    }
  }

  Widget _buildBody() {
    return BlocListener<DetailBloc, DetailState>(
      listener: handleListenableDetailBloc,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildContent(),
          _buildButton(),
        ],
      ),
    );
  }

  Widget _buildButton() {
    return DetailButtonWidget(widget.melonModel);
  }

  Widget _buildContent() {
    return Expanded(
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImages(),
            ReadMoreWidget(
              scrollController: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAuthorAndDownloadCount(),
                  Text('Created: ${widget.melonModel.uploadDate?.toLocal() ?? '???'}'),
                  Text('Description:\n${widget.melonModel.description}'),
                ],
              ),
            ),
            _buildTryMore(),
          ],
        ),
      ),
    );
  }

  Widget _buildImages() {
    return AspectRatio(
      aspectRatio: 12 / 16,
      child: ColoredBox(
        color: Colors.black,
        child: AppImageNetworkWidget(
          imageUrl: widget.melonModel.thumbnailUrl ?? '',
          fit: !isLivingSkin ? BoxFit.cover : BoxFit.contain,
          width: 100.w,
        ),
      ),
    );
  }

  bool get isLivingSkin => widget.melonModel.isLivingSkin ?? false;

  Column _buildTryMore() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('You may also like:'),
        BlocSelector<MelonModsBloc, MelonModsState, List<MelonModel>>(
          selector: (state) {
            if (state is MelonModsComplete) {
              final items = List<MelonModel>.from(state.items)..shuffle();
              items.remove(widget.melonModel);
              return items;
            }
            return [];
          },
          builder: (context, items) {
            return MasonryGridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return MelonWidget.home(
                  item: item,
                  isMoreSpace: index % 2 != 0,
                );
              },
            );
          },
        ),
      ],
    );
  }

  List<T> getRandomItems<T>(List<T> list, {int count = 4}) {
    if (list.length <= count) {
      return List.from(list);
    }
    list.shuffle(Random());
    return list.take(count).toList();
  }

  Row _buildAuthorAndDownloadCount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Author: ${widget.melonModel.author ?? '???'}'),
        Text('Downloads: ${widget.melonModel.downloadCount ?? 0}'),
      ],
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      titleSpacing: 0.0,
      title: Text(widget.melonModel.name ?? ''),
    );
  }
}
