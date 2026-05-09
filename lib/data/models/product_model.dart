/// Model data produk dari API praktikum
///
/// Response GET /api/products:
/// ```json
/// {
///   "success": true,
///   "message": "Draft products retrieved successfully.",
///   "products": [
///     {
///       "id": 1,
///       "name": "Macbook Pro M5 2026 - Silver",
///       "price": 32450000,
///       "description": "The MacBook Pro M5 2026",
///       "created_at": "2026-00-00 07:00:12",
///       "updated_at": "2026-00-00 07:00:12",
///       "user": { "username": "232410103076", "username": "Maulana Syahbana" },
///       "class": { "id": 5, "name": "TI-A" }
///     }
///   ]
/// }
/// ```
class ProductModel {
  final int id;
  final String name;
  final double price;
  final String description;
  final String? userId;   // username (NIM) pemilik produk
  final bool isDeleted;
  final DateTime? createdAt;

  const ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    this.userId,
    this.isDeleted = false,
    this.createdAt,
  });

  /// Buat ProductModel dari JSON response API
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // Ambil userId dari nested object user.username
    String? userId;
    final userObj = json['user'] as Map<String, dynamic>?;
    if (userObj != null) {
      userId = userObj['username']?.toString() ?? userObj['nim']?.toString();
    }
    userId ??= json['user_id']?.toString();

    return ProductModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      description: json['description']?.toString() ?? '',
      userId: userId,
      // Soft delete: ada field deleted_at yang tidak null
      isDeleted: json['deleted_at'] != null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }

  /// Konversi ke JSON untuk request POST /api/products
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price.toInt(), // API expect int
      'description': description,
    };
  }

  /// Buat salinan dengan field yang diubah
  ProductModel copyWith({
    int? id,
    String? name,
    double? price,
    String? description,
    String? userId,
    bool? isDeleted,
    DateTime? createdAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      userId: userId ?? this.userId,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() =>
      'ProductModel(id: $id, name: $name, price: $price, userId: $userId)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
