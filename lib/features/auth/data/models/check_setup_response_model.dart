/// Response model for check-setup endpoint.
///
/// Example response:
/// ```json
/// {
///   "isSetupCompleted": false,
///   "status": "ONBOARDING"
/// }
/// ```
class CheckSetupResponseModel {
  final bool isSetupCompleted;
  final String status;

  const CheckSetupResponseModel({
    required this.isSetupCompleted,
    required this.status,
  });

  factory CheckSetupResponseModel.fromJson(Map<String, dynamic> json) {
    // Handle nested data structure from API response
    final data = json['data'] as Map<String, dynamic>? ?? json;

    return CheckSetupResponseModel(
      isSetupCompleted: data['isSetupCompleted'] as bool? ?? false,
      status: data['status'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'isSetupCompleted': isSetupCompleted, 'status': status};
  }
}
