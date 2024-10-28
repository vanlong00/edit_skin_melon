import 'package:edit_skin_melon/features/home/models/melon_model.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../routing/app_route_name.dart';

enum MelonWidgetType { home, community }

class MelonWidget extends StatelessWidget {
  const MelonWidget.home({
    super.key,
    required this.item,
    this.type = MelonWidgetType.home,
  });

  const MelonWidget.community({
    super.key,
    required this.item,
    this.type = MelonWidgetType.community,
  });

  final MelonModel item;
  final MelonWidgetType type;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _funcToNavigate(context),
      child: _buildWidgetType(),
    );
  }

  Container _buildWidgetType() {
    switch (type) {
      case MelonWidgetType.community:
        return _buildCommunityWidget();
      case MelonWidgetType.home:
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

  void _funcToNavigate(BuildContext context) {
    Navigator.of(context).pushNamed(
      AppRouteName.detail,
      arguments: item,
    );
  }

  Container _buildCommunityWidget() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Image.network(
        item.thumbnailUrl ?? '',
        width: 100.w,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.none,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) {
            return child;
          }

          return AnimatedOpacity(
            // TODO: Consider making this configurable
            duration: const Duration(milliseconds: 300),
            opacity: frame == null ? 0 : 1,
            child: child,
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.image);
        },
      ),
    );
  }
}
