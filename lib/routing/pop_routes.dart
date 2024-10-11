import 'package:edit_skin_melon/packages/flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/material.dart';

Future<void> popRoute(BuildContext context) async {
  // Check if the EasyLoading overlay is active
  if (EasyLoading.isShow) {
    // Dismiss the overlay
    EasyLoading.dismiss();
    // Prevent route pop
    return;
  }

  if (!Navigator.of(context).canPop()) {
    // AppDialogExitApp.show(context);
    return;
  }
  // Allow route pop
  Navigator.of(context).pop();
}
