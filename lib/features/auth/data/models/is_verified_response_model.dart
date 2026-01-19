/// Response model for is-verified endpoint.
///
/// Example response:
/// ```json
/// {
///   "isVerified": true,
///   "status": "ACTIVE"
/// }
/// ```
class IsVerifiedResponseModel {
  final bool isVerified;
  final String status;

  const IsVerifiedResponseModel({
    required this.isVerified,
    required this.status,
  });

  factory IsVerifiedResponseModel.fromJson(Map<String, dynamic> json) {
    return IsVerifiedResponseModel(
      isVerified: json['isVerified'] as bool? ?? false,
      status: json['status'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'isVerified': isVerified, 'status': status};
  }
}
