import 'package:dartz/dartz.dart';
import 'package:mirath/core/error/failuors.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/add_paper_to_list_params.dart';
import '../repositories/reading_list_repository.dart';

class AddPaperToListUseCase implements UseCase<void, AddPaperToListParams> {
  final ReadingListRepository repository;

  AddPaperToListUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(AddPaperToListParams params) async {
    return await repository.addPaperToList(params);
  }
}
