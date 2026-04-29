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
    // Handle nested data structure from API response
    final data = json['data'] as Map<String, dynamic>? ?? json;

    return IsVerifiedResponseModel(
      isVerified: data['isVerified'] as bool? ?? false,
      status: data['status'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'isVerified': isVerified, 'status': status};
  }
}
