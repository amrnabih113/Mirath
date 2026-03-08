import 'package:dartz/dartz.dart';
import 'package:mirath/core/error/failuors.dart';
import 'package:mirath/core/usecases/usecase.dart';
import '../entites/highlight_entity.dart';
import '../repositories/annotation_repository.dart';

class GetHighlightsUseCase implements UseCase<List<Highlight>, String> {
  final AnnotationRepository repository;

  GetHighlightsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Highlight>>> call(String paperId) async {
    return await repository.getHighlights(paperId);
  }
}
