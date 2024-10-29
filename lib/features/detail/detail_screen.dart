import 'dart:math';

import 'package:edit_skin_melon/features/detail/widgets/read_more_widget.dart';
import 'package:edit_skin_melon/features/home/blocs/home/melon_mods_bloc.dart';
import 'package:edit_skin_melon/features/home/blocs/workspace/workspace_bloc.dart';
import 'package:edit_skin_melon/features/home/models/melon_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/app_image_network_widget.dart';
import '../home/widgets/melon_widget.dart';
import 'blocs/detail_bloc.dart';
import 'widgets/detail_button_widget.dart';

class DetailScreen extends StatefulWidget {
  final MelonModel melonModel;
  final String? tagImage;

  const DetailScreen({
    super.key,
    required this.melonModel,
    this.tagImage,
  });

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
          _buildContent(context),
          _buildButton(),
        ],
      ),
    );
  }

  Widget _buildButton() {
    return DetailButtonWidget(widget.melonModel);
  }

  Widget _buildContent(BuildContext context) {
    final EdgeInsets paddingSA = MediaQuery.paddingOf(context);
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(paddingSA.top),
                  _buildImages(),
                  const Gap(8),
                  _buildReadMore(),
                  const Divider(thickness: 2, height: 16,),
                  _buildTryMore(),
                ],
              ),
            ),
            Positioned(
              top: paddingSA.top,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  weight: 800,
                ),
                iconSize: 16,
                color: Colors.black,
                alignment: Alignment.center,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: const CircleBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ReadMoreWidget _buildReadMore() {
    return ReadMoreWidget(
      scrollController: _scrollController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAuthorAndDownloadCount(),
          Text('Created: ${widget.melonModel.uploadDate?.toLocal() ?? '???'}'),
          Text('Description:\n${widget.melonModel.description}'),
        ],
      ),
    );
  }

  Widget _buildImages() {
    return Hero(
      tag: widget.tagImage ?? 'detail-${widget.melonModel.id}',
      child: Container(
        width: 100.w,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8),
        ),
        clipBehavior: Clip.hardEdge,
        child: AppImageNetworkWidget(
          imageUrl: widget.melonModel.thumbnailUrl ?? '',
          fit: !isLivingSkin ? BoxFit.cover : BoxFit.contain,
          width: 100.w,
        ),
      ),
    );
  }

  bool get isLivingSkin => widget.melonModel.isLivingSkin ?? false;

  Widget _buildTryMore() {
    return FutureBuilder(
        future: Future.delayed(const Duration(milliseconds: 1200)),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('You may also like:'),
              const Gap(8),
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
                  return GridView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 12 / 16,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return MelonWidget.more(item: item);
                    },
                  );
                },
              ),
            ],
          );
        });
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
        Row(
          children: [
            const Icon(Icons.person_rounded),
            Text(widget.melonModel.author ?? '???'),
          ],
        ),
        Row(
          children: [
            const Icon(Icons.download_rounded),
            Text('${widget.melonModel.downloadCount ?? 0}'),
          ],
        ),
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
