import 'package:dartz/dartz.dart';

import '../../../../core/error/failuors.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/discussion.dart';
import '../repositories/community_repository.dart';

class GetDiscussionByIdUseCase implements UseCase<Discussion, String> {
  final CommunityRepository repository;

  GetDiscussionByIdUseCase(this.repository);

  @override
  Future<Either<Failure, Discussion>> call(String params) async {
    return await repository.getDiscussionById(params);
  }
}
