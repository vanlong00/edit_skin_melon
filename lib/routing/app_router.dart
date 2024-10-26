import 'dart:developer' as dev;

import 'package:edit_skin_melon/features/community_upload/screen/community_upload_screen.dart';
import 'package:edit_skin_melon/features/detail/detail_screen.dart';
import 'package:edit_skin_melon/features/detail/import_screen.dart';
import 'package:edit_skin_melon/features/home/blocs/community/community_melon_mods_bloc.dart';
import 'package:edit_skin_melon/features/home/blocs/home/melon_mods_bloc.dart';
import 'package:edit_skin_melon/features/home/blocs/workspace/workspace_bloc.dart';
import 'package:edit_skin_melon/features/home/home_screen.dart';
import 'package:edit_skin_melon/features/home/models/workspace_model.dart';
import 'package:edit_skin_melon/features/skin_editor/blocs/skin_editor/skin_editor_bloc.dart';
import 'package:edit_skin_melon/features/skin_editor/blocs/skin_item/skin_item_bloc.dart';
import 'package:edit_skin_melon/features/skin_editor/blocs/skin_part/skin_part_bloc.dart';
import 'package:edit_skin_melon/features/skin_editor/screens/skin_editor_completed_screen.dart';
import 'package:edit_skin_melon/features/skin_editor/screens/skin_editor_screen.dart';
import 'package:edit_skin_melon/features/skin_editor/screens/view_json_screen.dart';
import 'package:edit_skin_melon/features/splash/splash_screen.dart';
import 'package:edit_skin_melon/routing/app_route_name.dart';
import 'package:edit_skin_melon/tools/web_tools.dart';
import 'package:edit_skin_melon/widgets/error_widgets/error_no_route_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/di/di.dart';
import '../features/community_upload/blocs/community_upload_bloc.dart';
import '../features/detail/blocs/detail_bloc.dart';
import '../features/home/models/melon_model.dart';
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
      case AppRouteName.splash:
        return const SplashScreen();
      case AppRouteName.home:
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => getIt<MelonModsBloc>(),
            ),
            BlocProvider(
              create: (context) => getIt<CommunityMelonModsBloc>(),
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
      case AppRouteName.skinEditor:
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
      case AppRouteName.skinEditorCompleted:
        final args = settings.arguments as SkinEditorBloc;
        return BlocProvider.value(
          value: args,
          child: const SkinEditorCompletedScreen(),
        );
      case AppRouteName.viewJson:
        final args = settings.arguments as Map<String, dynamic>;
        return ViewJsonScreen(json: args);
      case AppRouteName.communityUpload:
        final item = settings.arguments as WorkspaceModel?;

        return BlocProvider(
          create: (context) => getIt<CommunityUploadBloc>(),
          child: CommunityUploadScreen(workspaceModel: item),
        );
      case AppRouteName.detail:
        final melonModel = settings.arguments as MelonModel;
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => getIt<DetailBloc>(),
            ),
            BlocProvider.value(
              value: getIt<WorkspaceBloc>(),
            ),
          ],
          child: DetailScreen(melonModel: melonModel),
        );
      case AppRouteName.import:
        final melonModel = settings.arguments as MelonModel;
        return ImportScreen(melonModel: melonModel);

      /// Web Tools
      case AppRouteName.webTools:
        return const WebTools();
      default:
        return const AppErrorNoRouteWidget();
    }
  }
}
