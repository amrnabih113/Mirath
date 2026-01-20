class FollowResponseModel {
  final String message;

  const FollowResponseModel({required this.message});

  factory FollowResponseModel.fromJson(Map<String, dynamic> json) {
    return FollowResponseModel(message: json['message'] ?? '');
  }

}
