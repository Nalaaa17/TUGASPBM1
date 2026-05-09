import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Wrapper aman untuk menyimpan Bearer Token menggunakan flutter_secure_storage
class TokenStorage {
  TokenStorage._();

  static const _storage = FlutterSecureStorage();

  static const String _tokenKey = 'bearer_token';
  static const String _nimKey = 'user_nim';
  static const String _nameKey = 'user_name';

  // ── Token ─────────────────────────────────────────────

  /// Simpan Bearer Token ke secure storage
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  /// Ambil Bearer Token dari secure storage
  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  /// Hapus Bearer Token (logout)
  static Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  /// Cek apakah token tersedia (untuk auto-login)
  static Future<bool> hasToken() async {
    final token = await _storage.read(key: _tokenKey);
    return token != null && token.isNotEmpty;
  }

  // ── User Info ─────────────────────────────────────────

  /// Simpan NIM pengguna
  static Future<void> saveNim(String nim) async {
    await _storage.write(key: _nimKey, value: nim);
  }

  /// Ambil NIM pengguna
  static Future<String?> getNim() async {
    return await _storage.read(key: _nimKey);
  }

  /// Simpan nama pengguna
  static Future<void> saveName(String name) async {
    await _storage.write(key: _nameKey, value: name);
  }

  /// Ambil nama pengguna
  static Future<String?> getName() async {
    return await _storage.read(key: _nameKey);
  }

  // ── Clear All ─────────────────────────────────────────

  /// Hapus semua data tersimpan (full logout)
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
