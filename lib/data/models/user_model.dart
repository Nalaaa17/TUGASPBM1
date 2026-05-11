class UserModel {
  final String nim; // username (NIM) mahasiswa
  final String token; // Bearer Token untuk autentikasi
  final String? name; // nama lengkap mahasiswa
  final String? className;

  const UserModel({
    required this.nim,
    required this.token,
    this.name,
    this.className,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final dataObj = json['data'] as Map<String, dynamic>?;
    final token =
        dataObj?['token']?.toString() ??
        json['token']?.toString() ??
        json['access_token']?.toString() ??
        '';

    final userObj =
        dataObj?['user'] as Map<String, dynamic>? ??
        json['user'] as Map<String, dynamic>?;

    final nim =
        userObj?['username']?.toString() ??
        userObj?['nim']?.toString() ??
        json['username']?.toString() ??
        '';

    final name = userObj?['name']?.toString() ?? json['name']?.toString();

    final classObj = userObj?['class'] as Map<String, dynamic>?;
    final className = classObj?['name']?.toString();

    return UserModel(nim: nim, token: token, name: name, className: className);
  }

  @override
  String toString() => 'UserModel(nim: $nim, name: $name, class: $className)';
}
