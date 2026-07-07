import 'package:dartz/dartz.dart';

import '../../../../core/error/failuors.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/feedback.dart';
import '../entities/submit_feedback_params.dart';
import '../repositories/chatbot_repository.dart';

class SubmitFeedbackUseCase implements UseCase<Feedback, SubmitFeedbackParams> {
  final ChatbotRepository repository;

  SubmitFeedbackUseCase(this.repository);

  @override
  Future<Either<Failure, Feedback>> call(SubmitFeedbackParams params) async {
    return await repository.submitFeedback(params);
  }
}
