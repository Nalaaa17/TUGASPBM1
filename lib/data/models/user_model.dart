/// Model data pengguna / respons login API praktikum
///
/// Response login dari server:
/// ```json
/// {
///   "success": true,
///   "message": "Login successful.",
///   "data": {
///     "token": "1|...",
///     "user": {
///       "id": 209,
///       "name": "Maulana Syahbana",
///       "username": "232410103076",
///       "class": { "id": 1, "name": "TI-A" }
///     }
///   }
/// }
/// ```
class UserModel {
  final String nim;       // username (NIM) mahasiswa
  final String token;     // Bearer Token untuk autentikasi
  final String? name;     // nama lengkap mahasiswa
  final String? className;

  const UserModel({
    required this.nim,
    required this.token,
    this.name,
    this.className,
  });

  /// Buat UserModel dari JSON response login API
  factory UserModel.fromJson(Map<String, dynamic> json) {
    // ── Ambil token dari: data.token ──────────────────────
    final dataObj = json['data'] as Map<String, dynamic>?;
    final token = dataObj?['token']?.toString() ??
        json['token']?.toString() ??
        json['access_token']?.toString() ??
        '';

    // ── Ambil info user dari: data.user ───────────────────
    final userObj = dataObj?['user'] as Map<String, dynamic>? ??
        json['user'] as Map<String, dynamic>?;

    // NIM = username mahasiswa
    final nim = userObj?['username']?.toString() ??
        userObj?['nim']?.toString() ??
        json['username']?.toString() ??
        '';

    // Nama lengkap
    final name = userObj?['name']?.toString() ?? json['name']?.toString();

    // Kelas: data.user.class.name
    final classObj = userObj?['class'] as Map<String, dynamic>?;
    final className = classObj?['name']?.toString();

    return UserModel(
      nim: nim,
      token: token,
      name: name,
      className: className,
    );
  }

  @override
  String toString() => 'UserModel(nim: $nim, name: $name, class: $className)';
}
