import 'package:dartz/dartz.dart';
import 'package:mirath/core/error/failuors.dart';
import 'package:mirath/core/usecases/usecase.dart';
import '../entites/highlight_entity.dart';
import '../repositories/annotation_repository.dart';

class UpdateHighlightUseCase implements UseCase<Highlight, Highlight> {
  final AnnotationRepository repository;

  UpdateHighlightUseCase(this.repository);

  @override
  Future<Either<Failure, Highlight>> call(Highlight highlight) async {
    return await repository.updateHighlight(highlight);
  }
}
