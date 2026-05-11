import '../models/user_model.dart';
import '../models/product_model.dart';
import 'api_service.dart';
import '../../core/utils/token_storage.dart';

/// Service untuk operasi autentikasi dan produk
///
/// Endpoint API Praktikum (base: https://task.itprojects.web.id):
///   - Login   : POST /api/auth/login
///   - Produk  : GET  /api/products
///   - Tambah  : POST /api/products
///   - Delete  : DELETE /api/products/{id}
///   - Submit  : POST /api/products/submit
class AuthService {
  AuthService._();

  // ── Endpoints ─────────────────────────────────────────
  static const String _loginEndpoint = '/api/auth/login';
  static const String _productsEndpoint = '/api/products';

  // ── Auth ──────────────────────────────────────────────

  /// Login dengan NIM sebagai username dan password
  ///
  /// Request body: { "username": NIM, "password": NIM }
  /// Response: { "success": true, "data": { "token": "...", "user": {...} } }
  static Future<UserModel> login(String nim, String password) async {
    final response = await ApiService.postPublic(_loginEndpoint, {
      'username': nim,   // API pakai 'username', bukan 'nim'
      'password': password,
    });

    final user = UserModel.fromJson(response);

    if (user.token.isEmpty) {
      throw const ApiException(
          'Token tidak ditemukan dalam response. Periksa NIM dan password kamu.');
    }

    // Simpan ke secure storage
    await TokenStorage.saveToken(user.token);
    await TokenStorage.saveNim(user.nim.isEmpty ? nim : user.nim);
    if (user.name != null) await TokenStorage.saveName(user.name!);

    return user;
  }

  /// Logout: hapus semua data dari secure storage
  static Future<void> logout() async {
    await TokenStorage.clearAll();
  }

  // ── Products ──────────────────────────────────────────

  /// Ambil semua draft produk milik pengguna yang sedang login
  ///
  /// API GET /api/products sudah otomatis filter berdasarkan Bearer Token.
  /// Response: { "success": true, "products": [...] }
  static Future<List<ProductModel>> getMyProducts() async {
    final list = await ApiService.getList(_productsEndpoint);

    // API sudah memfilter otomatis berdasarkan token — kembalikan semua
    final products = list
        .whereType<Map<String, dynamic>>()
        .map((json) => ProductModel.fromJson(json))
        .toList();

    return products;
  }

  /// Tambah draft produk baru
  ///
  /// Request body: { "name": string, "price": int, "description": string }
  static Future<ProductModel> addProduct({
    required String name,
    required double price,
    required String description,
  }) async {
    final response = await ApiService.post(_productsEndpoint, {
      'name': name,
      'price': price.toInt(),   // API expect integer
      'description': description,
    });

    // Coba ambil produk dari beberapa kemungkinan response structure
    final productData = response['data'] ??
        response['product'] ??
        response['products'] ??
        response;

    if (productData is Map<String, dynamic>) {
      return ProductModel.fromJson(productData);
    }
    if (productData is List && productData.isNotEmpty) {
      return ProductModel.fromJson(productData.first as Map<String, dynamic>);
    }

    // Fallback: buat model dari response + data yang dikirim
    return ProductModel(
      id: (response['id'] as num?)?.toInt() ?? DateTime.now().millisecondsSinceEpoch,
      name: name,
      price: price,
      description: description,
      createdAt: DateTime.now(),
    );
  }

  /// Soft delete produk
  ///
  /// DELETE /api/products/{id}
  static Future<void> deleteProduct(int productId) async {
    await ApiService.delete('$_productsEndpoint/$productId');
  }

  /// Submit Tugas Akhir
  ///
  /// POST /api/products/submit
  static Future<void> submitTugas({
    required String name,
    required double price,
    required String description,
    required String githubUrl,
  }) async {
    await ApiService.post('$_productsEndpoint/submit', {
      'name': name,
      'price': price.toInt(),
      'description': description,
      'github_url': githubUrl,
    });
  }
}

