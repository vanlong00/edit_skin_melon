import 'dart:math';

import 'package:edit_skin_melon/features/community/blocs/upload/community_upload_bloc.dart';
import 'package:edit_skin_melon/theme/app_color.dart';
import 'package:edit_skin_melon/widgets/app_text_field_widget/app_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

class CommunityUploadScreen extends StatefulWidget {
  const CommunityUploadScreen({super.key});

  @override
  State<CommunityUploadScreen> createState() => _CommunityUploadScreenState();
}

class _CommunityUploadScreenState extends State<CommunityUploadScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<AppTextFieldWidgetState> _keyName = GlobalKey();
  final GlobalKey<AppTextFieldWidgetState> _keyAuthor = GlobalKey();
  final GlobalKey<AppTextFieldWidgetState> _keyDescription = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTFName(),
                      _buildBlankSpace(),
                      _buildTFAuthor(),
                      _buildBlankSpace(),
                      _buildTFDescription(),
                      _buildBlankSpace(),
                      _buildThumbnailImage(),
                      _buildBlankSpace(),
                      _buildOptionalImage(),
                      _buildBlankSpace(),
                      _buildFileMod(),
                      _buildBlankSpace(),
                    ],
                  ),
                ),
              ),
              _buildButtonSubmit(),
            ],
          ),
        ),
      ),
    );
  }

  Gap _buildBlankSpace() => const Gap(8);

  SizedBox _buildButtonSubmit() {
    return SizedBox(
      width: 100.w,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {}
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text('Submit'),
      ),
    );
  }

  AppTextFieldWidget _buildTFDescription() {
    return AppTextFieldWidget.multiline(
      key: _keyDescription,
      label: 'Description',
      maxLines: 5,
    );
  }

  AppTextFieldWidget _buildTFAuthor() {
    return AppTextFieldWidget.name(
      key: _keyAuthor,
      label: 'Author',
    );
  }

  AppTextFieldWidget _buildTFName() {
    return AppTextFieldWidget.name(
      key: _keyName,
      label: 'Name',
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Upload'),
    );
  }

  Widget _buildThumbnailImage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Thumbnail'),
        _buildBlankSpace(),
        Container(
          width: 128,
          height: 128,
          decoration: BoxDecoration(
            color: AppColor.backgroundGame,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.image_rounded,
            size: 32,
          ),
        )
      ],
    );
  }

  Widget _buildOptionalImage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Image: (Up to 3 optional images)'),
        _buildBlankSpace(),
        Container(
          width: 128,
          height: 128,
          decoration: BoxDecoration(
            color: AppColor.backgroundGame,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.image_rounded,
            size: 32,
          ),
        )
      ],
    );
  }

  Widget _buildFileMod() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('File Mod\n(supported: .zip/.melmod)'),
            TextButton(
              onPressed: () {
                context.read<CommunityUploadBloc>().add(const CommunityUploadSelectFileEvent());
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Choose File'),
                  const Gap(4),
                  Transform.rotate(
                    angle: -15 * (pi / 180), // Convert 45 degrees to radians
                    child: const Icon(
                      Icons.attach_file_rounded,
                      size: 32,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        BlocSelector<CommunityUploadBloc, CommunityUploadState, XFile?>(
          selector: (state) => state.fileUpload,
          builder: (context, state) {
            if (state == null) {
              return const SizedBox();
            }

            return Text('File: ${state.name}');
          },
        ),
      ],
    );
  }
}
