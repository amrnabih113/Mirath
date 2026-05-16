import 'package:dartz/dartz.dart';
import '../../../../core/error/failuors.dart';
import '../entites/full_paper_entity.dart';

abstract class PaperRepository {
  Future<Either<Failure, FullPaperEntity>> getPaperById(String id);
}
