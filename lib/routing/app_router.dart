import 'dart:developer' as dev;

import 'package:edit_skin_melon/features/community/blocs/upload/community_upload_bloc.dart';
import 'package:edit_skin_melon/features/community/screen/community_upload_screen.dart';
import 'package:edit_skin_melon/features/home/blocs/home/melon_mods_bloc.dart';
import 'package:edit_skin_melon/features/home/blocs/workspace/workspace_bloc.dart';
import 'package:edit_skin_melon/features/home/home_screen.dart';
import 'package:edit_skin_melon/features/skin_editor/blocs/skin_editor/skin_editor_bloc.dart';
import 'package:edit_skin_melon/features/skin_editor/blocs/skin_item/skin_item_bloc.dart';
import 'package:edit_skin_melon/features/skin_editor/blocs/skin_part/skin_part_bloc.dart';
import 'package:edit_skin_melon/features/skin_editor/screens/skin_editor_completed_screen.dart';
import 'package:edit_skin_melon/features/skin_editor/screens/skin_editor_screen.dart';
import 'package:edit_skin_melon/features/skin_editor/screens/view_json_screen.dart';
import 'package:edit_skin_melon/features/splash/splash_screen.dart';
import 'package:edit_skin_melon/routing/app_routes.dart';
import 'package:edit_skin_melon/tools/web_tools.dart';
import 'package:edit_skin_melon/widgets/error_widgets/error_no_route_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/di/di.dart';
import 'pop_routes.dart';

class AppRouter {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) {
        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) async {
            /// Do something when the back button is pressed
            /// For example, show a dialog
            /// Or navigate to a different screen
            dev.log('PopScope: $didPop');
            if (!didPop) {
              await popRoute(context);
            } else {
              if (!Navigator.of(context).canPop()) {
                // AppDialogExitApp.show(context);
                return;
              }
            }
          },
          child: _getWidgetForRoute(settings),
        );
      },
      settings: settings,
    );
  }

  static _getWidgetForRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return const SplashScreen();
      case AppRoutes.home:
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => getIt<MelonModsBloc>(),
            ),
            BlocProvider(
              create: (context) => getIt<WorkspaceBloc>(),
            ),
            BlocProvider(
              create: (context) => getIt<SkinItemBloc>(),
            ),
          ],
          child: const HomeScreen(),
        );
      case AppRoutes.skinEditor:
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: getIt<SkinItemBloc>(),
            ),
            BlocProvider(
              create: (context) => getIt<SkinEditorBloc>(),
            ),
            BlocProvider(
              create: (context) => getIt<SkinPartBloc>(),
            ),
            BlocProvider.value(
              value: getIt<WorkspaceBloc>(),
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
      case AppRoutes.communityUpload:
        return BlocProvider(
          create: (context) => getIt<CommunityUploadBloc>(),
          child: const CommunityUploadScreen(),
        );

      /// Web Tools
      case AppRoutes.webTools:
        return const WebTools();
      default:
        return const AppErrorNoRouteWidget();
    }
  }
}
