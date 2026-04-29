import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String username;
  final String email;
  final String fullName;
  final String? photoUrl;
  final String? bio;
  final DateTime? birthDate;
  final String? country;
  final String levelOfEducation;
  final String? university;
  final String role;
  final String status;
  final bool isEmailVisible;
  final bool isPremium;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Interest> interests;
  final List<FieldOfStudy> fieldsOfStudy;
  final int followersCount;
  final int followingCount;
  final bool? isFollowed;

  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.fullName,
    this.photoUrl,
    this.bio,
    this.birthDate,
    this.country,
    required this.levelOfEducation,
    this.university,
    required this.role,
    required this.status,
    required this.isEmailVisible,
    required this.isPremium,
    required this.createdAt,
    required this.updatedAt,
    required this.interests,
    required this.fieldsOfStudy,
    required this.followersCount,
    required this.followingCount,
    this.isFollowed,
  });

  User copyWith({
    String? id,
    String? username,
    String? email,
    String? fullName,
    String? photoUrl,
    String? bio,
    DateTime? birthDate,
    String? country,
    String? levelOfEducation,
    String? university,
    String? role,
    String? status,
    bool? isEmailVisible,
    bool? isPremium,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<Interest>? interests,
    List<FieldOfStudy>? fieldsOfStudy,
    int? followersCount,
    int? followingCount,
    bool? isFollowed,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      photoUrl: photoUrl ?? this.photoUrl,
      bio: bio ?? this.bio,
      birthDate: birthDate ?? this.birthDate,
      country: country ?? this.country,
      levelOfEducation: levelOfEducation ?? this.levelOfEducation,
      university: university ?? this.university,
      role: role ?? this.role,
      status: status ?? this.status,
      isEmailVisible: isEmailVisible ?? this.isEmailVisible,
      isPremium: isPremium ?? this.isPremium,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      interests: interests ?? this.interests,
      fieldsOfStudy: fieldsOfStudy ?? this.fieldsOfStudy,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      isFollowed: isFollowed ?? this.isFollowed,
    );
  }

  @override
  List<Object?> get props => [
    id,
    username,
    email,
    fullName,
    photoUrl,
    bio,
    birthDate,
    country,
    levelOfEducation,
    university,
    role,
    status,
    isEmailVisible,
    isPremium,
    createdAt,
    updatedAt,
    interests,
    fieldsOfStudy,
    followersCount,
    followingCount,
    isFollowed,
  ];
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      fullName: json['fullName'],
      photoUrl: json['photoUrl'],
      bio: json['bio'],
      birthDate: json['birthDate'] != null
          ? DateTime.parse(json['birthDate'])
          : null,
      country: json['country'],
      levelOfEducation: json['levelOfEducation'],
      university: json['university'],
      role: json['role'],
      status: json['status'],
      isEmailVisible: json['isEmailVisible'],
      isPremium: json['isPremium'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      interests: (json['interests'] as List<dynamic>)
          .map((e) => Interest(id: e['id'], name: e['name']))
          .toList(),
      fieldsOfStudy: (json['fieldsOfStudy'] as List<dynamic>)
          .map((e) => FieldOfStudy(id: e['id'], name: e['name']))
          .toList(),
      followersCount: json['followersCount'],
      followingCount: json['followingCount'],
      isFollowed: json['isFollowed'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'fullName': fullName,
      'photoUrl': photoUrl,
      'bio': bio,
      'birthDate': birthDate?.toIso8601String(),
      'country': country,
      'levelOfEducation': levelOfEducation,
      'university': university,
      'role': role,
      'status': status,
      'isEmailVisible': isEmailVisible,
      'isPremium': isPremium,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'interests': interests
          .map((interest) => {'id': interest.id, 'name': interest.name})
          .toList(),
      'fieldsOfStudy': fieldsOfStudy
          .map((field) => {'id': field.id, 'name': field.name})
          .toList(),
      'followersCount': followersCount,
      'followingCount': followingCount,
    };
  }
}

class Interest extends Equatable {
  final String id;
  final String name;

  const Interest({required this.id, required this.name});

  @override
  List<Object> get props => [id, name];
}

class FieldOfStudy extends Equatable {
  final String id;
  final String name;

  const FieldOfStudy({required this.id, required this.name});

  @override
  List<Object> get props => [id, name];
}
