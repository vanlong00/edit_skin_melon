import 'package:dio/dio.dart';
import 'package:edit_skin_melon/core/utils/api_endpoints.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  GlobalKey<NavigatorState> navigatorKey() {
    return GlobalKey<NavigatorState>();
  }

  @lazySingleton
  Dio dio() {
    final dio = Dio();
    dio.options.baseUrl = ApiEndpoints.baseUrl;
    dio.options.connectTimeout = const Duration(seconds: 5);
    dio.options.receiveTimeout = const Duration(seconds: 3);
    dio.interceptors.add(
      PrettyDioLogger(
        responseBody: true,
        error: true,
        compact: true,
        maxWidth: 90,
        enabled: kDebugMode,
        filter: (options, args) {
          // don't print requests with uris containing '/posts'
          if (options.path.contains('/posts')) {
            return false;
          }
          // don't print responses with unit8 list data
          return !args.isResponse || !args.hasUint8ListData;
        },
      ),
    );

    return dio;
  }
}
