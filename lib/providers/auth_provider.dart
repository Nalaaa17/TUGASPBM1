import 'package:flutter/material.dart';
import '../core/utils/token_storage.dart';
import '../data/services/auth_service.dart';
import '../data/models/user_model.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

/// Provider untuk state autentikasi di seluruh aplikasi
class AuthProvider extends ChangeNotifier {
  AuthStatus _status = AuthStatus.unknown;
  UserModel? _user;
  String? _nim;
  String? _name;

  AuthStatus get status => _status;
  UserModel? get user => _user;
  bool get isLoggedIn => _status == AuthStatus.authenticated;
  String get displayName => _name ?? _nim ?? 'Pengguna';
  String get nim => _nim ?? '';
  String get className => _user?.className ?? '';

  /// Cek token yang ada saat startup (auto-login)
  Future<void> tryAutoLogin() async {
    final hasToken = await TokenStorage.hasToken();
    if (hasToken) {
      _nim = await TokenStorage.getNim();
      _name = await TokenStorage.getName();
      _status = AuthStatus.authenticated;
    } else {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  /// Login dengan NIM dan password
  Future<void> login(String nim, String password) async {
    _user = await AuthService.login(nim, password);
    _nim = _user!.nim.isEmpty ? nim : _user!.nim;
    _name = _user!.name;
    _status = AuthStatus.authenticated;
    notifyListeners();
  }

  /// Logout dan reset state
  Future<void> logout() async {
    await AuthService.logout();
    _user = null;
    _nim = null;
    _name = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }
}
