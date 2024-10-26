import 'package:edit_skin_melon/features/home/models/melon_model.dart';
import 'package:flutter/material.dart';

import '../../../../routing/app_route_name.dart';

class MelonWidget extends StatelessWidget {
  const MelonWidget({
    super.key,
    required this.item,
  });

  final MelonModel item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _funcToNavigate(context),
      child: Container(
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
      ),
    );
  }

  void _funcToNavigate(BuildContext context) {
    Navigator.of(context).pushNamed(
      AppRouteName.detail,
      arguments: item,
    );
  }
}
