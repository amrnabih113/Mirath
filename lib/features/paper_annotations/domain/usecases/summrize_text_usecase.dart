import 'package:dartz/dartz.dart';
import 'package:mirath/features/paper_annotations/domain/entites/summrize_text_params.dart';

import '../../../../core/error/failuors.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/annotation_repository.dart';

class SummrizeTextUseCase
    implements UseCase<String, SummrizeTextParams> {
  final AnnotationRepository repository;

  SummrizeTextUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(
    SummrizeTextParams params,
  ) async {
    return await repository.summarizeText(
      paperId: params.paperId,
      text: params.text,
    );
  }
}
