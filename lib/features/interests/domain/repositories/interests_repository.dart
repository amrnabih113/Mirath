import 'package:dartz/dartz.dart';

import '../../../../core/error/failuors.dart';
import '../entities/interest.dart';

abstract class InterestsRepository {
  /// Get all predefined interests from the server
  Future<Either<Failure, List<Interest>>> getAllInterests();

  /// Get a specific interest by its ID
  Future<Either<Failure, Interest>> getInterestById(String id);
}
