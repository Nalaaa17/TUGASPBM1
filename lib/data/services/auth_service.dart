import '../models/user_model.dart';
import '../models/product_model.dart';
import 'api_service.dart';
import '../../core/utils/token_storage.dart';

class AuthService {
  AuthService._();

  static const String _loginEndpoint = '/api/auth/login';
  static const String _productsEndpoint = '/api/products';

  static Future<UserModel> login(String nim, String password) async {
    final response = await ApiService.postPublic(_loginEndpoint, {
      'username': nim, // API pakai 'username', bukan 'nim'
      'password': password,
    });

    final user = UserModel.fromJson(response);

    if (user.token.isEmpty) {
      throw const ApiException(
        'Token tidak ditemukan dalam response. Periksa NIM dan password kamu.',
      );
    }

    await TokenStorage.saveToken(user.token);
    await TokenStorage.saveNim(user.nim.isEmpty ? nim : user.nim);
    if (user.name != null) await TokenStorage.saveName(user.name!);

    return user;
  }

  static Future<void> logout() async {
    await TokenStorage.clearAll();
  }

  static Future<List<ProductModel>> getMyProducts() async {
    final list = await ApiService.getList(_productsEndpoint);

    final products = list
        .whereType<Map<String, dynamic>>()
        .map((json) => ProductModel.fromJson(json))
        .toList();

    return products;
  }

  static Future<ProductModel> addProduct({
    required String name,
    required double price,
    required String description,
  }) async {
    final response = await ApiService.post(_productsEndpoint, {
      'name': name,
      'price': price.toInt(),
      'description': description,
    });

    final productData =
        response['data'] ??
        response['product'] ??
        response['products'] ??
        response;

    if (productData is Map<String, dynamic>) {
      return ProductModel.fromJson(productData);
    }
    if (productData is List && productData.isNotEmpty) {
      return ProductModel.fromJson(productData.first as Map<String, dynamic>);
    }

    return ProductModel(
      id:
          (response['id'] as num?)?.toInt() ??
          DateTime.now().millisecondsSinceEpoch,
      name: name,
      price: price,
      description: description,
      createdAt: DateTime.now(),
    );
  }

  static Future<void> deleteProduct(int productId) async {
    await ApiService.delete('$_productsEndpoint/$productId');
  }

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
