import 'package:dartz/dartz.dart';

import '../../../../core/error/failuors.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/chatbot_repository.dart';

class DeleteTemporarySessionUseCase implements UseCase<void, String> {
  final ChatbotRepository repository;

  DeleteTemporarySessionUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String params) async {
    return await repository.deleteTemporarySession(params);
  }
}
