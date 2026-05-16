import 'package:dartz/dartz.dart';

import '../../../../core/error/failuors.dart';
import '../../../../core/usecases/usecase.dart';
import '../entites/highlight_entity.dart';
import '../entites/highlight_note_params.dart';
import '../repositories/annotation_repository.dart';

class UpdateHighlightNoteUseCase
    implements UseCase<Highlight, HighlightNoteParams> {
  final AnnotationRepository repository;

  UpdateHighlightNoteUseCase(this.repository);

  @override
  Future<Either<Failure, Highlight>> call(HighlightNoteParams params) async {
    return await repository.updateHighlightNote(params);
  }
}
