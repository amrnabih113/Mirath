import 'package:dartz/dartz.dart';

import '../../../../core/error/failuors.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/chatbot_repository.dart';

class DeleteSessionUseCase implements UseCase<void, String> {
  final ChatbotRepository repository;

  DeleteSessionUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String params) async {
    return await repository.deleteSession(params);
  }
}
