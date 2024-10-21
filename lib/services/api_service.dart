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
    await _cacheManager.deleteByPrimaryKeyWithUri(
      Uri.parse(ApiEndpoints.baseUrl + ApiEndpoints.endPointCategory),
      requestMethod: "GET",
    );
  }

  Future<dynamic> getRequest(
    String endpoint, {
    Options? options,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: options ??
            buildCacheOptions(
              const Duration(days: 3),
              maxStale: const Duration(days: 7),
            ),
      );

      log(response.headers.value(DIO_CACHE_HEADER_KEY_DATA_SOURCE) != null
          ? "Data source data came from cache"
          : "Data source data came from network");

      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      log('Error: $e');
    }
  }

  Future<dynamic> postRequest(
    String endpoint, {
    required dynamic data,
    Options? options,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        options: options,
      );

      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      log('Error: $e');
    }
  }

  void _handleDioError(DioException error) {
    final errorMessage = {
          DioExceptionType.connectionTimeout: 'Connection timed out. Please try again later.',
          DioExceptionType.sendTimeout: 'Request timed out. Please try again later.',
          DioExceptionType.receiveTimeout: 'Server response timed out. Please try again later.',
          DioExceptionType.badResponse: 'Received an invalid response from the server. Please try again later.',
          DioExceptionType.cancel: 'Request was cancelled. Please try again.',
          DioExceptionType.unknown: 'An unexpected error occurred. Please try again later.',
          DioExceptionType.badCertificate: 'The server\'s certificate is not trusted.',
          DioExceptionType.connectionError:
              'A connection error occurred. Please check your internet connection and try again.',
        }[error.type] ??
        'An unexpected error occurred. Please try again later.';

    throw FailureException(error.response?.statusCode ?? 500, errorMessage);
  }
}

class FailureException implements Exception {
  final int code;
  final String message;

  FailureException(this.code, this.message);

  @override
  String toString() => 'FailureException(code: $code, message: $message)';
}
