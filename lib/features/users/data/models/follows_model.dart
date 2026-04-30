import 'package:mirath/features/users/domain/entities/follows.dart';

class FollowsModel extends Follows {
  FollowsModel({
    required super.message,
    required super.id,
    required super.username,
    required super.fullname,
    required super.photoUrl,
    required super.bio,
    required super.role,
    required super.status,
    required super.isPremium,
    required super.isFollowing,
  });

  factory FollowsModel.fromJson(Map<String, dynamic> json) {
    return FollowsModel(
      message: json['message'],
      id: json['data'][0]['id'],
      username: json['data'][0]['username'],
      fullname: json['data'][0]['fullname'],
      photoUrl: json['data'][0]['photoUrl'],
      bio: json['data'][0]['bio'],
      role: json['data'][0]['role'],
      status: json['data'][0]['status'],
      isPremium: json['data'][0]['isPremium'],
      isFollowing: json['data'][0]['isFollowing'],
    );
  }
}
