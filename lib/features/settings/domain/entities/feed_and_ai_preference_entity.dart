import 'package:equatable/equatable.dart';

class FeedAndAiPreferenceEntity extends Equatable {
  final bool showRecommendedPapers;
  final bool hideAlreadyReadPapers;
  final bool saveSearchHistory;

  const FeedAndAiPreferenceEntity({
    required this.showRecommendedPapers,
    required this.hideAlreadyReadPapers,
    required this.saveSearchHistory,
  });

  FeedAndAiPreferenceEntity copyWith({
    bool? showRecommendedPapers,
    bool? hideAlreadyReadPapers,
    bool? saveSearchHistory,
  }) {
    return FeedAndAiPreferenceEntity(
      showRecommendedPapers:
          showRecommendedPapers ?? this.showRecommendedPapers,
      hideAlreadyReadPapers:
          hideAlreadyReadPapers ?? this.hideAlreadyReadPapers,
      saveSearchHistory: saveSearchHistory ?? this.saveSearchHistory,
    );
  }

  @override
  List<Object?> get props => [
    showRecommendedPapers,
    hideAlreadyReadPapers,
    saveSearchHistory,
  ];
}
