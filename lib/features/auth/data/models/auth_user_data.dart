class AuthUserData {
  final String id;
  final String email;
  final String username;
  final String? photoURL;
  final String status;

  const AuthUserData({
    required this.id,
    required this.email,
    required this.username,
    this.photoURL,
    required this.status,
  });

  factory AuthUserData.fromJson(Map<String, dynamic> json) {
    return AuthUserData(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      photoURL: json['photoURL'],
      status: json['status'] ?? 'active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'photoURL': photoURL,
      'status': status,
    };
  }

  factory AuthUserData.empty() => AuthUserData(
    id: '',
    email: '',
    username: '',
    photoURL: null,
    status: 'inactive',
  );
}
