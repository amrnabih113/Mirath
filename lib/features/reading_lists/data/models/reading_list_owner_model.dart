import '../../domain/entities/reading_list_owner.dart';

class ReadingListOwnerModel extends ReadingListOwner {
  const ReadingListOwnerModel({
    required super.id,
    required super.username,
    required super.fullName,
    super.photoUrl,
  });

  factory ReadingListOwnerModel.fromJson(Map<String, dynamic> json) {
    return ReadingListOwnerModel(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      fullName: json['fullName'] ?? '',
      photoUrl: json['photoUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'fullName': fullName,
      if (photoUrl != null) 'photoUrl': photoUrl,
    };
  }
}
