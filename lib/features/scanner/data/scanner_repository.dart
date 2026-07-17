import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_endpoints.dart';
import '../../../core/api/dio_client.dart';
import '../../../core/api/providers.dart';
import '../domain/scanned_parcel.dart';

class ScannerRepository {
  ScannerRepository(this._dio);
  final DioClient _dio;

  Future<ScannedParcel?> lookup(String tracking) async {
    try {
      final data = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.lookupTracking(tracking),
      );
      final p = data['parcel'];
      if (p is Map) {
        return ScannedParcel.fromJson(Map<String, dynamic>.from(p));
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<void> setStatus({
    required int parcelId,
    required int status,
    String? note,
  }) =>
      _dio.post<dynamic>(
        ApiEndpoints.setStatus(parcelId),
        body: {
          'status': status,
          if (note != null && note.isNotEmpty) 'note': note,
        },
      );
}

final scannerRepositoryProvider = Provider<ScannerRepository>(
  (ref) => ScannerRepository(ref.watch(dioClientProvider)),
);
