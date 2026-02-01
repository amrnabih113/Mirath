class AuthUserData {
  final String id;
  final String email;
  final String username;
  final String fullName;
  final String? photoURL;
  final String status;

  const AuthUserData({
    required this.id,
    required this.email,
    required this.username,
    required this.fullName,
    this.photoURL,
    required this.status,
  });

  factory AuthUserData.fromJson(Map<String, dynamic> json) {
    return AuthUserData(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      fullName: json['fullName'] ?? json['username'] ?? '',
      photoURL: json['photoUrl'],
      status: json['status'] ?? 'active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'fullName': fullName,
      'photoUrl': photoURL,
      'status': status,
    };
  }

  factory AuthUserData.empty() => AuthUserData(
    id: '',
    email: '',
    username: '',
    fullName: '',
    photoURL: null,
    status: 'inactive',
  );
}
