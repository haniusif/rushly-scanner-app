import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../storage/tenant_storage.dart';
import '../storage/token_storage.dart';
import 'dio_client.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>(
  (ref) => const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  ),
);

final tokenStorageProvider = Provider<TokenStorage>(
  (ref) => TokenStorage(ref.watch(secureStorageProvider)),
);

final tenantStorageProvider = Provider<TenantStorage>(
  (ref) => TenantStorage(ref.watch(secureStorageProvider)),
);

final tenantBaseUrlProvider = FutureProvider<String?>(
  (ref) async => ref.watch(tenantStorageProvider).readBaseUrl(),
);

final dioClientProvider = Provider<DioClient>((ref) {
  final baseUrl = ref.watch(tenantBaseUrlProvider).valueOrNull;
  return DioClient(
    ref.watch(tokenStorageProvider),
    baseUrl: baseUrl,
  );
});
