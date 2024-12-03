class User {
  final String id;
  final String nama;
  final String alamat;
  final String no_hp;
  final String username;
  final String password;
  final String role;

  User({
    required this.id,
    required this.nama,
    required this.alamat,
    required this.no_hp,
    required this.username,
    required this.password,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      nama: json['nama'] ?? '',
      alamat: json['alamat'] ?? '',
      no_hp: json['no_hp'] ?? '',
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      role: json['role']?.toString() ?? '',
    );
  }
}
