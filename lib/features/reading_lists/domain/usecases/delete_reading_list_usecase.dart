import 'package:dartz/dartz.dart';

import '../../../../core/error/failuors.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/reading_list_repository.dart';

class DeleteReadingListUseCase implements UseCase<void, String> {
  final ReadingListRepository repository;

  DeleteReadingListUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String id) async {
    return await repository.deleteReadingList(id);
  }
}
