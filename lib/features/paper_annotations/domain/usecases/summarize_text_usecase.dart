import 'package:dartz/dartz.dart';
import 'package:mirath/features/paper_annotations/domain/entites/summarize_text_params.dart';

import '../../../../core/error/failuors.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/annotation_repository.dart';

class SummarizeTextUseCase
    implements UseCase<String, SummarizeTextParams> {
  final AnnotationRepository repository;

  SummarizeTextUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(
    SummarizeTextParams params,
  ) async {
    return await repository.summarizeText(
      paperId: params.paperId,
      text: params.text,
    );
  }
}
