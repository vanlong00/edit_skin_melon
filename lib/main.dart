import 'dart:io';

import 'package:edit_skin_melon/packages/flutter_easyloading/flutter_easyloading.dart';
import 'package:edit_skin_melon/routing/app_router.dart';
import 'package:edit_skin_melon/routing/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'core/di/di.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  configureDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) => MaterialApp(
        title: 'Flutter Demo',
        onGenerateRoute: AppRouter.generateRoute,
        initialRoute: Platform.isMacOS ? AppRoutes.webTools : AppRoutes.skinEditor,
        navigatorKey: getIt<GlobalKey<NavigatorState>>(),
        builder: EasyLoading.init(),
      ),
    );
  }
}
