/// Model data produk dari API praktikum
///
/// Response GET /api/products:
/// ```json
/// {
///   "success": true,
///   "message": "Draft products retrieved successfully.",
///   "products": [
///     {
///       "id": 2,
///       "name": "Macbook Pro M5 2026 - Silver",
///       "price": "32450000.00",
///       "description": "The MacBook Pro M5 2026...",
///       "created_at": "2026-05-08 07:40:15",
///       "updated_at": "2026-05-08 07:40:15",
///       "user": {
///         "id": 398,
///         "name": "DIAN EKA RAHAYU",
///         "username": "232410182006"
///       },
///       "class": { "id": 3, "name": "TI-A" }
///     }
///   ]
/// }
/// ```
class ProductModel {
  final int id;
  final String name;
  final double price;
  final String description;
  final String? userId;       // username (NIM) pemilik produk
  final String? ownerName;    // nama lengkap pemilik produk
  final String? ownerClass;   // kelas pemilik produk
  final bool isDeleted;
  final DateTime? createdAt;

  const ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    this.userId,
    this.ownerName,
    this.ownerClass,
    this.isDeleted = false,
    this.createdAt,
  });

  /// Buat ProductModel dari JSON response API
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // ── Parsing user info dari nested object ─────────────
    String? userId;
    String? ownerName;
    final userObj = json['user'] as Map<String, dynamic>?;
    if (userObj != null) {
      // username = NIM mahasiswa
      userId = userObj['username']?.toString();
      // nama lengkap pemilik
      ownerName = userObj['name']?.toString();
    }
    // Fallback jika tidak ada nested user
    userId ??= json['user_id']?.toString();

    // ── Parsing class info ───────────────────────────
    String? ownerClass;
    final classObj = json['class'] as Map<String, dynamic>?;
    if (classObj != null) {
      ownerClass = classObj['name']?.toString();
    }

    // ── Parsing harga (API bisa kirim string "32450000.00" atau int) ──
    double price = 0.0;
    final priceRaw = json['price'];
    if (priceRaw is num) {
      price = priceRaw.toDouble();
    } else if (priceRaw is String) {
      price = double.tryParse(priceRaw) ?? 0.0;
    }

    return ProductModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? '',
      price: price,
      description: json['description']?.toString() ?? '',
      userId: userId,
      ownerName: ownerName,
      ownerClass: ownerClass,
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
    String? ownerName,
    String? ownerClass,
    bool? isDeleted,
    DateTime? createdAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      userId: userId ?? this.userId,
      ownerName: ownerName ?? this.ownerName,
      ownerClass: ownerClass ?? this.ownerClass,
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
