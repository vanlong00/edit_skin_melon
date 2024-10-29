import 'package:edit_skin_melon/core/di/di.dart';
import 'package:edit_skin_melon/routing/app_route_name.dart';
import 'package:edit_skin_melon/services/pre_init_data.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await getIt<PreInitData>().initialize();

      if (!context.mounted) return;
      Navigator.pushReplacementNamed(context, AppRouteName.home);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
