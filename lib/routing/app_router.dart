import 'package:edit_skin_melon/routing/app_routes.dart';
import 'package:flutter/material.dart';

import '../features/skin_editor/screens/skin_editor_screen.dart';
import '../widgets/error_widgets/error_no_route_widget.dart';

class AppRouter {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (context) => _getWidgetForRoute(settings),
    );
  }

  static _getWidgetForRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.skinEditor:
        return const SkinEditorScreen();
      default:
        return const Scaffold(body: AppErrorNoRouteWidget());
    }
  }
}
