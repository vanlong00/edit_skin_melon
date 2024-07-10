import 'package:edit_skin_melon/features/skin_editor/blocs/skin_editor_bloc.dart';
import 'package:edit_skin_melon/features/skin_editor/screens/view_json_screen.dart';
import 'package:edit_skin_melon/routing/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/di/di.dart';
import '../features/skin_editor/screens/skin_editor_screen.dart';
import '../widgets/error_widgets/error_no_route_widget.dart';

class AppRouter {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => _getWidgetForRoute(settings),
    );
  }

  static _getWidgetForRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.skinEditor:
        return BlocProvider(
          create: (context) => getIt<SkinEditorBloc>(),
          child: const SkinEditorScreen(),
        );
      case AppRoutes.viewJson:
        return BlocProvider(
          create: (context) => getIt<SkinEditorBloc>(),
          child: const ViewJsonScreen(),
        );
      default:
        return const AppErrorNoRouteWidget();
    }
  }
}
