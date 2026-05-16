import 'package:dartz/dartz.dart';

import '../../../../core/error/failuors.dart';
import '../../../../core/usecases/usecase.dart';
import '../entites/highlight_entity.dart';
import '../repositories/annotation_repository.dart';

class SaveHighlightUseCase implements UseCase<Highlight, Highlight> {
  final AnnotationRepository repository;

  SaveHighlightUseCase(this.repository);

  @override
  Future<Either<Failure, Highlight>> call(Highlight highlight) async {
    return await repository.saveHighlight(highlight);
  }
}
