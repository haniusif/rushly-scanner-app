import 'package:dio/dio.dart';

class ApiException implements Exception {
  ApiException(this.message, {this.statusCode});
  final String message;
  final int? statusCode;

  factory ApiException.fromDio(DioException e) {
    final code = e.response?.statusCode;
    final data = e.response?.data;
    String msg = e.message ?? 'Network error';
    if (data is Map && data['message'] != null) {
      msg = data['message'].toString();
    }
    return ApiException(msg, statusCode: code);
  }

  @override
  String toString() => message;
}
