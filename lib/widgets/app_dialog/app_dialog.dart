import 'package:edit_skin_melon/core/utils/app_string.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class AppDialog {
  static void showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Exit App"),
          content: const Text("Are you sure you want to exit the app?"),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.all(4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: Colors.grey,
              ),
              child: const Text("Cancel"),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.all(4),
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("Exit"),
            ),
          ],
        );
      },
    );
  }

  static void showActionDialog(
    BuildContext context, {
    required String title,
    required String content,
    Color? actionColor,
    Function()? onAction,
    String? actionText,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.all(4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: Colors.grey,
              ),
              child: const Text("Cancel"),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
                onAction?.call();
              },
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.all(4),
                backgroundColor: actionColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(actionText ?? "Do"),
            ),
          ],
        );
      },
    );
  }

  static Future<void> showTermOfServiceDialog(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final acceptTime = prefs.getString("TERM_OF_SERVICE");

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AppAlertDialog(
          title: const Text("Term of Service"),
          content: const SingleChildScrollView(
            child: Text(AppString.kTermOfService),
          ),
          action: [
            SizedBox(
              width: 100.w,
              child: FilledButton(
                onPressed: () {
                  var time = DateTime.now().toString().substring(0, 16).toString();
                  prefs.setString("TERM_OF_SERVICE", time);
                  Navigator.of(context).pop();
                },
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                ),
                child: acceptTime != null ? Text("You accepted on\n$acceptTime") : const Text("OK"),
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<void> showPrivacyPolicyDialog(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final acceptTime = prefs.getString("TIME_POLICY");

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AppAlertDialog(
          title: const Text("Privacy Policy"),
          content: const SingleChildScrollView(
            child: Text(AppString.kPrivacyPolicy),
          ),
          action: [
            SizedBox(
              width: 100.w,
              child: FilledButton(
                onPressed: () {
                  var time = DateTime.now().toString().substring(0, 16).toString();
                  prefs.setString("TIME_POLICY", time);
                  Navigator.of(context).pop();
                },
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                ),
                child: acceptTime != null ? Text("You accepted on\n$acceptTime") : const Text("OK"),
              ),
            ),
          ],
        );
      },
    );
  }
}

class AppAlertDialog extends StatelessWidget {
  const AppAlertDialog({
    super.key,
    this.title,
    this.content,
    this.action,
  });

  final Widget? title;
  final Widget? content;
  final List<Widget>? action;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title,
      content: content,
      actions: action,
    );
  }
}
