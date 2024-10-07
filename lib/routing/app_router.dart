import 'package:edit_skin_melon/core/utils/helpers/navigation_helper.dart';
import 'package:edit_skin_melon/features/skin_editor/blocs/skin_editor/skin_editor_bloc.dart';
import 'package:edit_skin_melon/features/skin_editor/blocs/skin_item/skin_item_bloc.dart';
import 'package:edit_skin_melon/features/skin_editor/blocs/skin_part/skin_part_bloc.dart';
import 'package:edit_skin_melon/features/skin_editor/screens/skin_editor_completed_screen.dart';
import 'package:edit_skin_melon/features/skin_editor/screens/view_json_screen.dart';
import 'package:edit_skin_melon/routing/app_routes.dart';
import 'package:edit_skin_melon/tools/web_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/di/di.dart';
import '../features/skin_editor/screens/skin_editor_screen.dart';
import '../widgets/error_widgets/error_no_route_widget.dart';

class AppRouter {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => _getWidgetForRoute(settings),
      settings: settings,
    );
  }

  static _getWidgetForRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.skinEditor:
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => getIt<SkinItemBloc>(),
            ),
            BlocProvider(
              create: (context) => getIt<SkinEditorBloc>(),
            ),
            BlocProvider(
              create: (context) => getIt<SkinPartBloc>(),
            ),
          ],
          child: const SkinEditorScreen(),
        );
      case AppRoutes.skinEditorCompleted:
        final args = settings.arguments as SkinEditorBloc;
        return BlocProvider.value(
          value: args,
          child: const SkinEditorCompletedScreen(),
        );
      case AppRoutes.viewJson:
        final args = settings.arguments as Map<String, dynamic>;
        return ViewJsonScreen(json: args);
      case AppRoutes.webTools:
        return const WebTools();
      default:
        return const AppErrorNoRouteWidget();
    }
  }
}
