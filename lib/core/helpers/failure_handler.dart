import '../error/failuors.dart';

/// A utility class for handling failures following Clean Architecture principles.
///
/// Provides centralized failure handling logic that can be reused across cubits.
///
/// Usage:
/// ```dart
/// result.fold(
///   (failure) => FailureHandler.handle(
///     failure: failure,
///     onUnauthorized: () => emit(state.copyWith(status: Status.unauthenticated)),
///     onError: (message) => emit(state.copyWith(status: Status.error, message: message)),
///   ),
///   (success) => // handle success,
/// );
/// ```
class FailureHandler {
  FailureHandler._();

  /// Handles a failure by checking its type and calling the appropriate callback.
  static void handle({
    required Failure failure,
    required void Function() onUnauthorized,
    required void Function(String message) onError,
  }) {
    if (failure is UnauthorizedFailure) {
      onUnauthorized();
    } else {
      onError(failure.message);
    }
  }

  /// Checks if the failure is an unauthorized failure.
  static bool isUnauthorized(Failure failure) => failure is UnauthorizedFailure;
}
