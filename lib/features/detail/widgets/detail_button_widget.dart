import 'package:edit_skin_melon/features/home/blocs/workspace/workspace_bloc.dart';
import 'package:edit_skin_melon/features/home/models/melon_model.dart';
import 'package:edit_skin_melon/routing/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../blocs/detail_bloc.dart';

class DetailButtonWidget extends StatelessWidget {
  final MelonModel melonModel;

  const DetailButtonWidget(
    this.melonModel, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.w,
      child: BlocSelector<WorkspaceBloc, WorkspaceState, bool>(
        selector: (state) {
          final history = state.melonItems;
          return history.any((element) => element.id == melonModel.id);
        },
        builder: (context, isDownloaded) {
          if (isDownloaded) {
            return _buildImportButton(context);
          }
          return _buildDownloadButton(context);
        },
      ),
    );
  }

  ElevatedButton _buildDownloadButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.read<DetailBloc>().add(DetailStartedDownload(melonModel.fileUrl));
      },
      style: _buildStyleFrom(),
      child: Text('Download'.toUpperCase()),
    );
  }

  ElevatedButton _buildImportButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pushNamed(AppRoutes.import, arguments: melonModel);
      },
      style: _buildStyleFrom(),
      child: Text('Import'.toUpperCase()),
    );
  }

  ButtonStyle _buildStyleFrom() {
    return ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
    );
  }
}
