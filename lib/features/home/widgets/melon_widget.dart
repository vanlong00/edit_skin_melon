import 'package:edit_skin_melon/features/home/models/melon_model.dart';
import 'package:edit_skin_melon/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sizer/sizer.dart';

import '../../../routing/app_route_name.dart';
import '../../../widgets/app_image_network_widget.dart';

enum MelonWidgetType { home, community }

class MelonWidget extends StatelessWidget {
  const MelonWidget.home({
    super.key,
    required this.item,
    this.type = MelonWidgetType.home,
    this.isMoreSpace = false,
  });

  const MelonWidget.community({
    super.key,
    required this.item,
    this.type = MelonWidgetType.community,
    this.isMoreSpace = false,
  });

  final MelonModel item;
  final MelonWidgetType type;
  final bool isMoreSpace;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _funcToNavigate(context),
      child: _buildWidgetType(),
    );
  }

  bool get isLivingMods => item.isLivingSkin == true;

  Container _buildWidgetType() {
    switch (type) {
      case MelonWidgetType.community:
        return _buildCommunityWidget();
      case MelonWidgetType.home:
        return Container(
          decoration: BoxDecoration(
            color: AppColor.backgroundGame,
            borderRadius: BorderRadius.circular(8),
          ),
          clipBehavior: Clip.hardEdge,
          child: AspectRatio(
            aspectRatio: 9 / 16,
            child: AppImageNetworkWidget(
              imageUrl: item.thumbnailUrl ?? '',
              fit: isLivingMods ? BoxFit.contain : BoxFit.cover,
              width: 100.w,
            ),
          ),
        );
    }
  }

  void _funcToNavigate(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.of(context).pop();
    }

    Navigator.of(context).pushNamed(
      AppRouteName.detail,
      arguments: item,
    );
  }

  Container _buildCommunityWidget() {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: EdgeInsets.only(top: isMoreSpace ? 56 : 0),
      decoration: BoxDecoration(
        color: AppColor.backgroundGame,
        borderRadius: BorderRadius.circular(8),
      ),
      child: AppImageNetworkWidget(
        width: 100.w,
        height: 100.h,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.none,
        imageUrl: item.thumbnailUrl ?? '',
      ),
    );
  }
}
