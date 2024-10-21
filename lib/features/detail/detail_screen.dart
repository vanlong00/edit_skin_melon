import 'package:edit_skin_melon/features/home/blocs/workspace/workspace_bloc.dart';
import 'package:edit_skin_melon/features/home/models/melon_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/detail_bloc.dart';
import 'widgets/detail_button_widget.dart';

class DetailScreen extends StatelessWidget {
  final MelonModel melonModel;

  const DetailScreen({super.key, required this.melonModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  void handleListenableDetailBloc(BuildContext context, DetailState state) {
    if (state is DetailDownloadSuccess) {
      context.read<WorkspaceBloc>().add(AddMelonEvent(melonModel));
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
    return DetailButtonWidget(melonModel);
  }

  Widget _buildContent() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text('Author: ${melonModel.author}'),
            Text('Description: ${melonModel.description}'),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(melonModel.name ?? ''),
    );
  }
}
