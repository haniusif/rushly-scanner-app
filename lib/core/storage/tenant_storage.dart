import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Persists the tenant (courier company subdomain) the app is
/// currently connected to. Same shape and keys as the other Rushly
/// mobile apps so users can share the "which workspace am I on"
/// muscle memory.
class TenantStorage {
  TenantStorage(this._storage);
  final FlutterSecureStorage _storage;

  static const _baseUrlKey = 'tenant_api_base';
  static const _labelKey = 'tenant_label';

  Future<String?> readBaseUrl() => _storage.read(key: _baseUrlKey);
  Future<String?> readLabel() => _storage.read(key: _labelKey);

  Future<void> write({required String baseUrl, required String label}) async {
    await _storage.write(key: _baseUrlKey, value: baseUrl);
    await _storage.write(key: _labelKey, value: label);
  }

  Future<void> clear() async {
    await _storage.delete(key: _baseUrlKey);
    await _storage.delete(key: _labelKey);
  }

  Future<bool> isConfigured() async {
    final v = await readBaseUrl();
    return v != null && v.isNotEmpty;
  }
}
