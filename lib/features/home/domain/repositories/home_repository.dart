import 'package:dartz/dartz.dart';

import '../../../../core/error/failuors.dart';
import '../entities/paper_entity.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<PaperEntity>>> getRecentPapers({
    String? category,
    int page = 1,
    int limit = 10,
  });

  Future<Either<Failure, List<PaperEntity>>> getRecommendations({
    int page = 1,
    int limit = 5,
  });
}
