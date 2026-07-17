import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../config/env.dart';
import '../error/api_exception.dart';
import '../storage/token_storage.dart';

/// [baseUrl] is resolved at construction from TenantStorage via
/// dioClientProvider. Change-workspace clears the token + returns to
/// the tenant-select screen, which invalidates the provider.
class DioClient {
  DioClient(this._tokens, {String? baseUrl}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? Env.apiBaseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {'Accept': 'application/json', 'apiKey': Env.apiKey},
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _tokens.readToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (e, handler) async {
          if (e.response?.statusCode == 401) {
            await _tokens.clear();
            _onUnauthorized?.call();
          }
          handler.next(e);
        },
      ),
    );

    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestBody: true,
          responseBody: true,
          requestHeader: false,
          compact: true,
        ),
      );
    }
  }

  late final Dio _dio;
  final TokenStorage _tokens;
  VoidCallback? _onUnauthorized;
  set onUnauthorized(VoidCallback? cb) => _onUnauthorized = cb;

  Future<T> get<T>(String path, {Map<String, dynamic>? query}) async {
    try {
      final res = await _dio.get<dynamic>(path, queryParameters: query);
      return _unwrap<T>(res.data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<T> post<T>(String path, {Object? body}) async {
    try {
      final res = await _dio.post<dynamic>(path, data: body);
      return _unwrap<T>(res.data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  T _unwrap<T>(dynamic data) {
    if (data is Map<String, dynamic> && data.containsKey('data')) {
      return data['data'] as T;
    }
    return data as T;
  }
}
