class SubmitFeedbackParams {
  final String sessionId;
  final String messageId;
  final String feedbackType;

  SubmitFeedbackParams({
    required this.sessionId,
    required this.messageId,
    required this.feedbackType,
  });
}
