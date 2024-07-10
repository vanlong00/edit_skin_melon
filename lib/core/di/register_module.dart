import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  GlobalKey<NavigatorState> navigatorKey() {
    return GlobalKey<NavigatorState>();
  }
}
