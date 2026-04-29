import 'package:dartz/dartz.dart';
import 'package:mirath/core/error/failuors.dart';
import 'package:mirath/core/usecases/usecase.dart';
import '../entites/highlight_entity.dart';
import '../entites/paper_highlights_params.dart';
import '../repositories/annotation_repository.dart';

class GetAnnotatedHighlightsUseCase
    implements UseCase<List<Highlight>, PaperHighlightsParams> {
  final AnnotationRepository repository;

  GetAnnotatedHighlightsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Highlight>>> call(
    PaperHighlightsParams params,
  ) async {
    return await repository.getAnnotatedHighlights(params);
  }
}
