import '../error/error_messages.dart';
import '../error/exceptions.dart';
import '../error/failuors.dart';

Failure mapExceptionToFailure(Object e) {
  if (e is ServerException) {
    return ServerFailure(e.message ?? ErrorMessages.server);
  }
  if (e is NetworkException) {
    return NetworkFailure(e.message ?? ErrorMessages.network);
  }
  if (e is TimeoutException) {
    return TimeoutFailure(e.message ?? ErrorMessages.timeout);
  }
  if (e is UnauthorizedException) {
    return UnauthorizedFailure(e.message ?? ErrorMessages.unauthorized);
  }
  if (e is CacheException) {
    return CacheFailure(e.message ?? ErrorMessages.cache);
  }
  if (e is NotFoundException) {
    return NotFoundFailure(e.message ?? ErrorMessages.notFound);
  }
  if (e is ConflictException) {
    return ConflictFailure(e.message ?? ErrorMessages.conflict);
  }
  if (e is ValidationException) {
    return ValidationFailure(e.message ?? ErrorMessages.validation);
  }
  if (e is UnexpectedException) {
    return UnexpectedFailure(e.message ?? ErrorMessages.unexpected);
  }
  return const UnexpectedFailure();
}
