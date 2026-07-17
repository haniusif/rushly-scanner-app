import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_endpoints.dart';
import '../../../core/api/dio_client.dart';
import '../../../core/api/providers.dart';
import '../../../core/storage/token_storage.dart';

class AuthRepository {
  AuthRepository(this._dio, this._tokens);
  final DioClient _dio;
  final TokenStorage _tokens;

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final data = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.login,
      body: {'email': email, 'password': password},
    );
    final token = data['token'] as String;
    await _tokens.writeToken(token);
    return data;
  }

  Future<Map<String, dynamic>> profile() =>
      _dio.get<Map<String, dynamic>>(ApiEndpoints.profile);

  Future<void> logout() async {
    try {
      await _dio.post<dynamic>(ApiEndpoints.logout);
    } finally {
      await _tokens.clear();
    }
  }
}

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(
    ref.watch(dioClientProvider),
    ref.watch(tokenStorageProvider),
  ),
);
