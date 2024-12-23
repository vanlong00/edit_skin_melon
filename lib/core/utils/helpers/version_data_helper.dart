import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dio_http_cache_fix/dio_http_cache.dart';
import 'package:edit_skin_melon/core/utils/api_endpoints.dart';
import 'package:edit_skin_melon/services/api_service.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class VersionDataHelper {
  final ApiService _apiService;

  VersionDataHelper(this._apiService);

  Future<void> checkDataServer() async {
    final prefs = await SharedPreferences.getInstance();
    final localVersion = prefs.getString('versionData');

    try {
      final response = await _apiService.getRequest(
        ApiEndpoints.endPointGetVersion,
        options:
            Options(extra: {DIO_CACHE_KEY_TRY_CACHE: false}), // Disable cache
      );
      final networkVersion = response;

      if (networkVersion != localVersion) {
        // Update local version data
        prefs.setString('versionData', networkVersion);

        // Clear all cache
        log('Clearing cache');
        await _apiService.deleteCacheEndpointDataOwner();
      }
    } catch (e) {
      // Handle the error
      log('Error checking version data: $e');
    }
  }
}
