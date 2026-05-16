import 'package:dartz/dartz.dart';
import '../../../../core/error/failuors.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/reading_list_repository.dart';

class RemovePaperParams {
  final String readingListId;
  final String paperId;

  const RemovePaperParams({required this.readingListId, required this.paperId});
}

class RemovePaperFromListUseCase implements UseCase<void, RemovePaperParams> {
  final ReadingListRepository repository;

  RemovePaperFromListUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(RemovePaperParams params) async {
    return await repository.removePaperFromList(
      readingListId: params.readingListId,
      paperId: params.paperId,
    );
  }
}
