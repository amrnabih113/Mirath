import 'package:dartz/dartz.dart';

import '../error/failuors.dart';
import 'no_params.dart';

/// UseCase contract: implement call with [Params] and return [Either<Failure, R>]
/// To use:
/// final Either<Failure, User> result = await useCase(42);
///
/// result.fold(
///   (failure) => handleFailure(failure),
///   (user) => handleUser(user),
/// );

abstract class UseCase<R, P> {
  Future<Either<Failure, R>> call(P params);
}

/// Convenience typedef for NoParams
typedef UseCaseNoParams<R> = UseCase<R, NoParams>;
