import 'package:edit_skin_melon/routing/app_route_name.dart';
import 'package:edit_skin_melon/routing/app_router.dart';
import 'package:edit_skin_melon/widgets/loading_widgets/loading_animate_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';

import 'core/di/di.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb ? HydratedStorage.webStorageDirectory : await getApplicationDocumentsDirectory(),
  );

  configureDependencies();

  runApp(const MyApp());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..indicatorWidget = const LoadingAnimateWidgets()
    ..loadingStyle = EasyLoadingStyle.custom
    ..backgroundColor = Colors.transparent
    ..indicatorColor = Colors.transparent
    ..boxShadow = []
    ..maskType = EasyLoadingMaskType.custom
    ..maskColor = Colors.black.withOpacity(0.24)
    ..textColor = Colors.black;
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
        initialRoute: AppRouteName.splash,
        // initialRoute: Platform.isMacOS ? AppRoutes.webTools : AppRoutes.skinEditor,
        navigatorKey: getIt<GlobalKey<NavigatorState>>(),
        builder: EasyLoading.init(),
      ),
    );
  }
}
