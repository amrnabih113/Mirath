import 'package:mirath/features/settings/domain/entities/privacy_settings_entitiy.dart';

class PrivacySettingsModel extends PrivacySettingsEntitiy {
  PrivacySettingsModel({
    required super.isPrivateAccount,
    required super.allowProfileSearch,
    required super.allowPublicComments,
    required super.useReadingBehaviorForRecommendations,
    required super.blockedAccounts,
  });

  factory PrivacySettingsModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    return PrivacySettingsModel(
      isPrivateAccount: data['isPrivateAccount'],
      allowProfileSearch: data['allowProfileSearch'],
      allowPublicComments: data['allowPublicComments'],
      useReadingBehaviorForRecommendations:
          data[' useReadingBehaviorForRecommendations'],
      blockedAccounts:
          (data['blockedAccounts'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
  Map<String, dynamic> toJson() => {
    'isPrivateAccount': isPrivateAccount,
    'allowProfileSearch': allowProfileSearch,
    'allowPublicComments': allowPublicComments,
    'useReadingBehaviorForRecommendations':
        useReadingBehaviorForRecommendations,
    'blockedAccounts': blockedAccounts,
  };
}
