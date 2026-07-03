import 'package:mirath/features/settings/domain/entities/feed_and_ai_preference_entity.dart';

class FeedAndAiPreferenceModel extends FeedAndAiPreferenceEntity {
  const FeedAndAiPreferenceModel({
    required super.showRecommendedPapers,
    required super.hideAlreadyReadPapers,
    required super.saveSearchHistory,
  });
  factory FeedAndAiPreferenceModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    return FeedAndAiPreferenceModel(
      showRecommendedPapers: data['showRecommendedPapers'] ?? false,
      hideAlreadyReadPapers: data['hideAlreadyReadPapers'] ?? false,
      saveSearchHistory: data['saveSearchHistory'] ?? false,
    );
  }
  factory FeedAndAiPreferenceModel.fromEntity(
    FeedAndAiPreferenceEntity entity,
  ) {
    return FeedAndAiPreferenceModel(
      showRecommendedPapers: entity.showRecommendedPapers,
      hideAlreadyReadPapers: entity.hideAlreadyReadPapers,
      saveSearchHistory: entity.saveSearchHistory,
    );
  }

  Map<String, dynamic> toJson() => {
    'showRecommendedPapers': showRecommendedPapers,
    'hideAlreadyReadPapers': hideAlreadyReadPapers,
    'saveSearchHistory': saveSearchHistory,
  };
}
