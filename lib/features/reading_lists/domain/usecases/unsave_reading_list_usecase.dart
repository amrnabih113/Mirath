import 'package:dartz/dartz.dart';
import 'package:mirath/core/error/failuors.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/reading_list_repository.dart';

class UnsaveReadingListUseCase implements UseCase<void, String> {
  final ReadingListRepository repository;

  UnsaveReadingListUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String id) async {
    return await repository.unsaveReadingList(id);
  }
}
