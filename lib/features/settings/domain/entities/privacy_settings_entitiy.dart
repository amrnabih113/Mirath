class PrivacySettingsEntitiy {
  final bool isPrivateAccount;
  final bool allowProfileSearch;
  final bool allowPublicComments;
  final bool useReadingBehaviorForRecommendations;
  final List<String> blockedAccounts;

  PrivacySettingsEntitiy({
    required this.isPrivateAccount,
    required this.allowProfileSearch,
    required this.allowPublicComments,
    required this.useReadingBehaviorForRecommendations,
    required this.blockedAccounts,
  });
}
