import '../../domain/entities/follows.dart';

class FollowsModel extends Follows {
  FollowsModel({
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
      id: (json['id'] ?? '').toString(),
      username: (json['username'] ?? '').toString(),
      fullname: (json['fullName'] ?? json['fullname'] ?? '').toString(),
      photoUrl: (json['photoUrl'] ?? '').toString(),
      bio: (json['bio'] ?? '').toString(),
      role: (json['role'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      isPremium: json['isPremium'] == true,
      isFollowing: json['isFollowing'] == true,
    );
  }

  static List<FollowsModel> listFromResponse(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is! List) {
      return const [];
    }

    return data
        .whereType<Map>()
        .map((item) => FollowsModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }
}
