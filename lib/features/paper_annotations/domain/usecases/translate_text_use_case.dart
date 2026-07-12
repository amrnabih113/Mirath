import 'package:dartz/dartz.dart';
import 'package:mirath/core/error/failuors.dart';
import 'package:mirath/core/usecases/usecase.dart';
import 'package:mirath/features/paper_annotations/domain/entites/translate_text_params.dart';
import 'package:mirath/features/paper_annotations/domain/repositories/annotation_repository.dart';

class TranslateTextUseCase
    implements UseCase<String, TranslateTextParams> {
  final AnnotationRepository repository;

  TranslateTextUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(
    TranslateTextParams params,
  ) async {
    return await repository.translateText(
      paperId: params.paperId,
      text: params.text,
      targetLanguage: params.targetLanguage,
    );
  }
}