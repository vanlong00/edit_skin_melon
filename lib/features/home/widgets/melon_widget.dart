import 'package:edit_skin_melon/features/home/models/melon_model.dart';
import 'package:edit_skin_melon/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../routing/app_route_name.dart';
import '../../../widgets/app_image_network_widget.dart';

enum MelonWidgetType { home, community, more, history }

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

  const MelonWidget.more({
    super.key,
    required this.item,
    this.type = MelonWidgetType.more,
    this.isMoreSpace = false,
  });

  const MelonWidget.history({
    super.key,
    required this.item,
    this.type = MelonWidgetType.history,
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

  Widget _buildWidgetType() {
    switch (type) {
      case MelonWidgetType.community:
        return _buildCommunityWidget();
      case MelonWidgetType.home:
        return _buildHomeWidget();
      case MelonWidgetType.more:
        return _buildMoreWidget();
      case MelonWidgetType.history:
        // TODO: Handle this case.
        return _buildHomeWidget(tag: 'history-${item.id}');
    }
  }

  Container _buildMoreWidget() {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.backgroundGame,
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.hardEdge,
      child: AppImageNetworkWidget(
        imageUrl: item.thumbnailUrl ?? '',
        fit: isLivingMods ? BoxFit.contain : BoxFit.cover,
        width: 100.w,
      ),
    );
  }

  Widget _buildHomeWidget({String? tag}) {
    return Hero(
      tag: tag ?? "home-${item.id}",
      transitionOnUserGestures: true,
      child: Container(
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
      ),
    );
  }

  void _funcToNavigate(BuildContext context) {
    // if (Navigator.canPop(context)) {
    //   Navigator.of(context).pop();
    // }

    switch (type) {
      case MelonWidgetType.more:
        Navigator.of(context).pushNamed(
          AppRouteName.detailMore,
          arguments: {'item': item},
        );
        break;
      case MelonWidgetType.history:
        Navigator.of(context).pushNamed(
          AppRouteName.detail,
          arguments: {'item': item, 'tag': 'history-${item.id}'},
        );
        break;
      default:
        Navigator.of(context).pushNamed(
          AppRouteName.detail,
          arguments: {'item': item, 'tag': 'home-${item.id}'},
        );
        break;
    }
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
