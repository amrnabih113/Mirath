import 'package:dartz/dartz.dart';
import 'package:mirath/features/paper_annotations/domain/entites/explain_text_params.dart';

import '../../../../core/error/failuors.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/annotation_repository.dart';

class ExplainTextUseCase
    implements UseCase<String, ExplainTextParams> {
  final AnnotationRepository repository;

  ExplainTextUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(
    ExplainTextParams params,
  ) async {
    return await repository.explainText(
      paperId: params.paperId,
      text: params.text,
    );
  }
}
