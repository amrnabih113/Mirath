import 'package:mirath/features/settings/domain/entities/privacy_settings_entitiy.dart';

class PrivacySettingsModel extends PrivacySettingsEntitiy {
  const PrivacySettingsModel({
    required super.isPrivateAccount,
    required super.allowProfileSearch,
    required super.allowPublicComments,
    required super.useReadingBehaviorForRecommendations,
    required super.blockedAccounts,
  });

  factory PrivacySettingsModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    return PrivacySettingsModel(
      isPrivateAccount: data['isPrivateAccount'] ?? false,
      allowProfileSearch: data['allowProfileSearch'] ?? false,
      allowPublicComments: data['allowPublicComments'] ?? false,
      useReadingBehaviorForRecommendations:
          data['useReadingBehaviorForRecommendations'] ?? false,
      blockedAccounts:
          (data['blockedAccounts'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
  factory PrivacySettingsModel.fromEntity(PrivacySettingsEntitiy entity) {
    return PrivacySettingsModel(
      isPrivateAccount: entity.isPrivateAccount,
      allowProfileSearch: entity.allowProfileSearch,
      allowPublicComments: entity.allowPublicComments,
      useReadingBehaviorForRecommendations:
          entity.useReadingBehaviorForRecommendations,
      blockedAccounts: entity.blockedAccounts,
    );
  }

  Map<String, dynamic> toJson() => {
    'isPrivateAccount': isPrivateAccount,
    'allowProfileSearch': allowProfileSearch,
    'allowPublicComments': allowPublicComments,
    'useReadingBehaviorForRecommendations':
        useReadingBehaviorForRecommendations,
  };
}
