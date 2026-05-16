import 'package:dartz/dartz.dart';
import '../../../../core/error/failuors.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/reading_list.dart';
import '../repositories/reading_list_repository.dart';

class GetReadingListByIdUseCase implements UseCase<ReadingList, String> {
  final ReadingListRepository repository;

  GetReadingListByIdUseCase(this.repository);

  @override
  Future<Either<Failure, ReadingList>> call(String id) async {
    return await repository.getReadingListById(id);
  }
}
