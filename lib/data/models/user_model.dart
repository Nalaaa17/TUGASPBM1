/// Model data pengguna / respons login API praktikum
///
/// Response login dari server:
/// ```json
/// {
///   "success": true,
///   "message": "Login successful.",
///   "data": {
///     "token": "...",
///     "user": {
///       "id": 209,
///       "name": "Maulana Syahbana",
///       "username": "232410103076",
///       "nim": 3,
///       "class": { "id": 1, "name": "TI-A" }
///     }
///   }
/// }
/// ```
class UserModel {
  final String nim;
  final String token;
  final String? name;
  final String? className;

  const UserModel({
    required this.nim,
    required this.token,
    this.name,
    this.className,
  });

  /// Buat UserModel dari JSON response login API
  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Token ada di nested: data.token
    final dataObj = json['data'] as Map<String, dynamic>?;
    final token = dataObj?['token']?.toString() ??
        json['token']?.toString() ??
        json['access_token']?.toString() ??
        '';

    // User info ada di nested: data.user
    final userObj = dataObj?['user'] as Map<String, dynamic>? ??
        json['user'] as Map<String, dynamic>?;

    // username = NIM mahasiswa
    final nim = userObj?['username']?.toString() ??
        userObj?['nim']?.toString() ??
        json['username']?.toString() ??
        '';

    final name = userObj?['name']?.toString() ?? json['name']?.toString();

    // Kelas mahasiswa: data.user.class.name
    final classObj = userObj?['class'] as Map<String, dynamic>?;
    final className = classObj?['name']?.toString();

    return UserModel(nim: nim, token: token, name: name, className: className);
  }

  @override
  String toString() => 'UserModel(nim: $nim, name: $name, class: $className)';
}
