import 'package:dartz/dartz.dart';
import '../../../../core/error/failuors.dart';
import '../../../../core/usecases/usecase.dart';
import '../entites/highlight_note_params.dart';
import '../repositories/annotation_repository.dart';

class DeleteHighlightNoteUseCase implements UseCase<void, HighlightNoteParams> {
  final AnnotationRepository repository;

  DeleteHighlightNoteUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(HighlightNoteParams params) async {
    return await repository.deleteHighlightNote(params);
  }
}
