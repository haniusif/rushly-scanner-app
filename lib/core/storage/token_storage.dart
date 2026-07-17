import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  TokenStorage(this._storage);
  final FlutterSecureStorage _storage;

  static const _tokenKey = 'auth_token';
  static const _userKey = 'auth_user';

  Future<String?> readToken() => _storage.read(key: _tokenKey);
  Future<void> writeToken(String t) => _storage.write(key: _tokenKey, value: t);

  Future<String?> readUser() => _storage.read(key: _userKey);
  Future<void> writeUser(String u) => _storage.write(key: _userKey, value: u);

  Future<void> clear() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _userKey);
  }
}
