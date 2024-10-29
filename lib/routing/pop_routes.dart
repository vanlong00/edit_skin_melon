import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../widgets/app_dialog/app_dialog.dart';

Future<void> popRoute(BuildContext context) async {
  // Check if the EasyLoading overlay is active
  if (EasyLoading.isShow) {
    // Dismiss the overlay
    EasyLoading.dismiss();
    // Prevent route pop
    return;
  }

  if (!Navigator.of(context).canPop()) {
    AppDialog.showExitDialog(context);
    return;
  }
  // Allow route pop
  Navigator.of(context).pop();
}
