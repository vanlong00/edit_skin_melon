import 'package:flutter/material.dart';

import '../../di/di.dart';

class NavigationHelper {
  static NavigatorState get navigator => Navigator.of(context);

  static BuildContext get context => getIt<GlobalKey<NavigatorState>>().currentState!.context;
}
