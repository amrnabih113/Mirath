import 'package:equatable/equatable.dart';

class PrivacySettingsEntitiy extends Equatable {
  final String message;
  final bool isPrivateAccount;
  final bool allowProfileSearch;
  final bool allowPublicComments;
  final bool useReadingBehaviorForRecommendations;
  final List<String> blockedAccounts;

  const PrivacySettingsEntitiy({
    required this.isPrivateAccount,
    required this.allowProfileSearch,
    required this.allowPublicComments,
    required this.useReadingBehaviorForRecommendations,
    required this.blockedAccounts, required this.message,
  });
  PrivacySettingsEntitiy copyWith({
    bool? isPrivateAccount,
    bool? allowProfileSearch,
    bool? allowPublicComments,
    bool? useReadingBehaviorForRecommendations,
    List<String>? blockedAccounts,
  }) {
    return PrivacySettingsEntitiy(
      message: message,
      isPrivateAccount: isPrivateAccount ?? this.isPrivateAccount,
      allowProfileSearch: allowProfileSearch ?? this.allowProfileSearch,
      allowPublicComments: allowPublicComments ?? this.allowPublicComments,
      useReadingBehaviorForRecommendations:
          useReadingBehaviorForRecommendations ??
          this.useReadingBehaviorForRecommendations,
      blockedAccounts: [], 
    );
  }

  @override
  List<Object?> get props => [
    isPrivateAccount,
    allowProfileSearch,
    allowPublicComments,
    useReadingBehaviorForRecommendations,
  ];
}
