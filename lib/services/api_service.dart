import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dio_http_cache_fix/dio_http_cache.dart';
import 'package:injectable/injectable.dart';

import '../core/utils/api_endpoints.dart';

@lazySingleton
class ApiService {
  final Dio _dio;
  final DioCacheManager _cacheManager;

  ApiService(this._dio) : _cacheManager = DioCacheManager(CacheConfig(baseUrl: ApiEndpoints.baseUrl)) {
    _dio.interceptors.add(_cacheManager.interceptor);
  }

  Future<void> clearCache() async {
    await _cacheManager.clearAll();
  }

  Future<void> deleteCacheEndpointDataOwner() async {
  }

  Future<dynamic> getRequest(String endpoint, {Options? options}) async {
    try {
      final response = await _dio.get(
        endpoint,
        options: options ??
            buildCacheOptions(
              const Duration(days: 3),
              maxStale: const Duration(days: 7),
            ), // Default cache for 7 days
      );

      if (null != response.headers.value(DIO_CACHE_HEADER_KEY_DATA_SOURCE)) {
        // data come from cache
        log("Data source data came from cache");
      } else {
        // data come from net
        log("Data source data came from network");
      }

      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      throw FailureException(500, 'An unexpected error occurred. Please try again later.');
    }
  }

  void _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        throw FailureException(408, 'Connection timed out. Please try again later.');
      case DioExceptionType.sendTimeout:
        throw FailureException(408, 'Request timed out. Please try again later.');
      case DioExceptionType.receiveTimeout:
        throw FailureException(408, 'Server response timed out. Please try again later.');
      case DioExceptionType.badResponse:
        throw FailureException(
          error.response?.statusCode ?? 500,
          'Received an invalid response from the server. Please try again later.',
        );
      case DioExceptionType.cancel:
        throw FailureException(499, 'Request was cancelled. Please try again.');
      case DioExceptionType.unknown:
        throw FailureException(500, 'An unexpected error occurred. Please try again later.');
      case DioExceptionType.badCertificate:
        throw FailureException(495, 'The server\'s certificate is not trusted.');
      case DioExceptionType.connectionError:
        throw FailureException(
            500, 'A connection error occurred. Please check your internet connection and try again.');
    }
  }
}

class FailureException implements Exception {
  final int code;
  final String message;

  FailureException(this.code, this.message);

  @override
  String toString() => 'FailureException(code: $code, message: $message)';
}
