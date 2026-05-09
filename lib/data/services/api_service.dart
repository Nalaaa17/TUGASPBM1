import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../core/utils/token_storage.dart';
import '../../core/constants/app_strings.dart';

/// Custom exception untuk error API
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException($statusCode): $message';
}

/// HTTP Client dengan Bearer Token injection otomatis
///
/// ⚠️  KONFIGURASI: Ubah [baseUrl] dengan URL server API praktikum kamu
class ApiService {
  ApiService._();

  // ── KONFIGURASI ───────────────────────────────────────
  // Base URL server API praktikum
  static const String baseUrl = 'https://task.itprojects.web.id';

  static const Duration _timeout = Duration(seconds: 30);

  // ── Headers ───────────────────────────────────────────

  /// Buat header standar tanpa auth (untuk login)
  static Map<String, String> _baseHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  /// Buat header dengan Bearer Token (untuk request terautentikasi)
  static Future<Map<String, String>> _authHeaders() async {
    final token = await TokenStorage.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  // ── HTTP Methods ──────────────────────────────────────

  /// GET request dengan Bearer Token
  static Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final headers = await _authHeaders();
      final response = await http
          .get(Uri.parse('$baseUrl$endpoint'), headers: headers)
          .timeout(_timeout);
      return _handleResponse(response);
    } on SocketException {
      throw const ApiException(AppStrings.errorNetwork);
    } on HttpException {
      throw const ApiException(AppStrings.errorNetwork);
    } on Exception catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw const ApiException('Koneksi timeout. Coba lagi.');
      }
      throw ApiException(AppStrings.errorUnknown);
    }
  }

  /// GET request yang mengembalikan List
  static Future<List<dynamic>> getList(String endpoint) async {
    try {
      final headers = await _authHeaders();
      final response = await http
          .get(Uri.parse('$baseUrl$endpoint'), headers: headers)
          .timeout(_timeout);
      return _handleListResponse(response);
    } on SocketException {
      throw const ApiException(AppStrings.errorNetwork);
    } on Exception catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw const ApiException('Koneksi timeout. Coba lagi.');
      }
      rethrow;
    }
  }

  /// POST request tanpa auth (khusus login)
  static Future<Map<String, dynamic>> postPublic(
      String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl$endpoint'),
            headers: _baseHeaders(),
            body: jsonEncode(body),
          )
          .timeout(_timeout);
      return _handleResponse(response);
    } on SocketException {
      throw const ApiException(AppStrings.errorNetwork);
    } on Exception catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw const ApiException('Koneksi timeout. Coba lagi.');
      }
      rethrow;
    }
  }

  /// POST request dengan Bearer Token
  static Future<Map<String, dynamic>> post(
      String endpoint, Map<String, dynamic> body) async {
    try {
      final headers = await _authHeaders();
      final response = await http
          .post(
            Uri.parse('$baseUrl$endpoint'),
            headers: headers,
            body: jsonEncode(body),
          )
          .timeout(_timeout);
      return _handleResponse(response);
    } on SocketException {
      throw const ApiException(AppStrings.errorNetwork);
    } on Exception catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw const ApiException('Koneksi timeout. Coba lagi.');
      }
      rethrow;
    }
  }

  /// DELETE request dengan Bearer Token
  static Future<Map<String, dynamic>> delete(String endpoint) async {
    try {
      final headers = await _authHeaders();
      final response = await http
          .delete(Uri.parse('$baseUrl$endpoint'), headers: headers)
          .timeout(_timeout);
      return _handleResponse(response);
    } on SocketException {
      throw const ApiException(AppStrings.errorNetwork);
    } on Exception catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw const ApiException('Koneksi timeout. Coba lagi.');
      }
      rethrow;
    }
  }

  // ── Response Handler ──────────────────────────────────

  static Map<String, dynamic> _handleResponse(http.Response response) {
    final body = _decodeBody(response.body);

    switch (response.statusCode) {
      case 200:
      case 201:
        if (body is Map<String, dynamic>) return body;
        return {'data': body};

      case 401:
        throw ApiException(AppStrings.errorUnauthorized,
            statusCode: response.statusCode);

      case 422:
        // Validation error dari server
        final errors = body['errors'] ?? body['message'] ?? 'Validasi gagal';
        throw ApiException(errors.toString(),
            statusCode: response.statusCode);

      case 500:
      case 502:
      case 503:
        throw ApiException(AppStrings.errorServer,
            statusCode: response.statusCode);

      default:
        final message = body['message']?.toString() ?? AppStrings.errorUnknown;
        throw ApiException(message, statusCode: response.statusCode);
    }
  }

  static List<dynamic> _handleListResponse(http.Response response) {
    final body = _decodeBody(response.body);

    if (response.statusCode == 401) {
      throw const ApiException(AppStrings.errorUnauthorized, statusCode: 401);
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (body is List) return body;
      if (body is Map<String, dynamic>) {
        // Response API praktikum: { "success": true, "products": [...] }
        if (body['products'] is List) return body['products'] as List;
        // Fallback lain
        if (body['data'] is List) return body['data'] as List;
        if (body['items'] is List) return body['items'] as List;
      }
      return [];
    }

    throw ApiException(AppStrings.errorUnknown,
        statusCode: response.statusCode);
  }

  static dynamic _decodeBody(String body) {
    try {
      return jsonDecode(body);
    } catch (_) {
      return <String, dynamic>{};
    }
  }
}
