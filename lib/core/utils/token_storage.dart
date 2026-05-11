import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  TokenStorage._();

  static const _storage = FlutterSecureStorage();

  static const String _tokenKey = 'bearer_token';
  static const String _nimKey = 'user_nim';
  static const String _nameKey = 'user_name';

  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  static Future<bool> hasToken() async {
    final token = await _storage.read(key: _tokenKey);
    return token != null && token.isNotEmpty;
  }

  static Future<void> saveNim(String nim) async {
    await _storage.write(key: _nimKey, value: nim);
  }

  static Future<String?> getNim() async {
    return await _storage.read(key: _nimKey);
  }

  static Future<void> saveName(String name) async {
    await _storage.write(key: _nameKey, value: name);
  }

  static Future<String?> getName() async {
    return await _storage.read(key: _nameKey);
  }

  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
