import 'package:dartz/dartz.dart';
import 'package:mirath/core/error/failuors.dart';
import 'package:mirath/core/usecases/usecase.dart';
import '../repositories/annotation_repository.dart';

class DeleteHighlightUseCase implements UseCase<void, String> {
  final AnnotationRepository repository;

  DeleteHighlightUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String highlightId) async {
    return await repository.deleteHighlight(highlightId);
  }
}
