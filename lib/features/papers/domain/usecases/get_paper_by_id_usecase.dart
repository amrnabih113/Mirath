import 'package:dartz/dartz.dart';
import '../../../../core/error/failuors.dart';
import '../entites/full_paper_entity.dart';
import '../../../../core/usecases/usecase.dart';
import '../repository/paper_repository.dart';

class GetPaperByIdUseCase implements UseCase<FullPaperEntity, String> {
  final PaperRepository repository;

  GetPaperByIdUseCase(this.repository);

  @override
  Future<Either<Failure, FullPaperEntity>> call(String params) async {
    return await repository.getPaperById(params);
  }
}
