import 'package:dartz/dartz.dart';
import 'package:mirath/core/error/failuors.dart';
import 'package:mirath/features/papers/domain/entites/full_paper_entity.dart';

abstract class PaperRepository {
  Future<Either<Failure, FullPaperEntity>> getPaperById(String id);
}
