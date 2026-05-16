import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';

import 'error_messages.dart';
import 'exceptions.dart' as ex;

abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => message;
}

// ====== Specific Failures ======

class ServerFailure extends Failure {
  const ServerFailure([super.message = ErrorMessages.server]);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = ErrorMessages.network]);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure([super.message = ErrorMessages.timeout]) : super();
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = ErrorMessages.unauthorized])
    : super();
}

class ForbiddenFailure extends Failure {
  const ForbiddenFailure([super.message = ErrorMessages.forbidden]) : super();
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = ErrorMessages.cache]) : super();
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = ErrorMessages.notFound]) : super();
}

class ConflictFailure extends Failure {
  const ConflictFailure([super.message = ErrorMessages.conflict]) : super();
}

class ValidationFailure extends Failure {
  const ValidationFailure([super.message = ErrorMessages.validation]) : super();
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = ErrorMessages.unexpected]) : super();
}

class GoogleSignInFailure extends Failure {
  const GoogleSignInFailure([super.message = ErrorMessages.googleSignInFailed])
    : super();
}

class AppleSignInFailure extends Failure {
  const AppleSignInFailure([super.message = ErrorMessages.appleSignInFailed])
    : super();
}

/// Extracts a user-friendly error message from API response data.
///
/// Handles various response formats:
/// - `{"message": "string"}` → returns the string
/// - `{"message": ["error1", "error2"]}` → joins with newlines
/// - `{"error": "string"}` → returns the error string
/// - Other formats → returns null
String? _extractErrorMessage(dynamic data) {
  if (data == null) return null;

  if (data is Map<String, dynamic>) {
    // Handle "message" field (can be string or array)
    final message = data['message'];
    if (message is String) {
      return message;
    }
    if (message is List) {
      return message.whereType<String>().join('\n');
    }

    // Handle "error" field
    final error = data['error'];
    if (error is String && error.toLowerCase() != 'bad request') {
      return error;
    }

    // Handle "errors" field (array of error objects)
    final errors = data['errors'];
    if (errors is List) {
      final messages = <String>[];
      for (final e in errors) {
        if (e is String) {
          messages.add(e);
        } else if (e is Map && e['message'] is String) {
          messages.add(e['message'] as String);
        }
      }
      if (messages.isNotEmpty) {
        return messages.join('\n');
      }
    }
  }

  if (data is String && data.isNotEmpty) {
    return data;
  }

  return null;
}

/// Map any [exception] into a domain [Failure].
Failure mapExceptionToFailure(Object? exception) {
  if (exception == null) return const UnexpectedFailure();

  // If it's already a Failure, return it.
  if (exception is Failure) return exception;

  // Handle our custom exceptions (from exceptions.dart)
  if (exception is ex.ServerException) {
    return ServerFailure(exception.message ?? ErrorMessages.server);
  }
  if (exception is ex.CacheException) {
    return CacheFailure(exception.message ?? ErrorMessages.cache);
  }
  if (exception is ex.NetworkException) {
    return NetworkFailure(exception.message ?? ErrorMessages.network);
  }
  if (exception is ex.TimeoutException) {
    return TimeoutFailure(exception.message ?? ErrorMessages.timeout);
  }
  if (exception is ex.UnauthorizedException) {
    return UnauthorizedFailure(exception.message ?? ErrorMessages.unauthorized);
  }
  if (exception is ex.ForbiddenException) {
    return ForbiddenFailure(exception.message ?? ErrorMessages.forbidden);
  }
  if (exception is ex.ValidationException) {
    return ValidationFailure(exception.message ?? ErrorMessages.validation);
  }
  if (exception is ex.NotFoundException) {
    return NotFoundFailure(exception.message ?? ErrorMessages.notFound);
  }
  if (exception is ex.ConflictException) {
    return ConflictFailure(exception.message ?? ErrorMessages.conflict);
  }
  if (exception is ex.EmptyResponseException) {
    return UnexpectedFailure(exception.message ?? 'No content returned.');
  }
  if (exception is ex.ParsingException) {
    return UnexpectedFailure(exception.message ?? 'Failed to parse response.');
  }

  // Dio errors (Dio v5 uses DioException)
  if (exception is DioException) {
    final DioException dio = exception;

    final typeStr = dio.type.toString().toLowerCase();

    // Cancelled
    if (typeStr.contains('cancel')) {
      return const UnexpectedFailure(ErrorMessages.cancelled);
    }

    // Timeouts
    if (typeStr.contains('timeout')) {
      return const TimeoutFailure();
    }

    // Network / socket issues
    if (dio.error is SocketException) {
      return const NetworkFailure();
    }

    // If server responded, map by status code
    final response = dio.response;
    if (response != null) {
      final status = response.statusCode ?? 0;
      final errorMessage = _extractErrorMessage(response.data);

      if (status == 400) {
        return ValidationFailure(errorMessage ?? ErrorMessages.validation);
      }
      if (status == 401) {
        return UnauthorizedFailure(errorMessage ?? ErrorMessages.unauthorized);
      }
      if (status == 403) {
        return ForbiddenFailure(errorMessage ?? ErrorMessages.forbidden);
      }
      if (status == 404) {
        return NotFoundFailure(errorMessage ?? ErrorMessages.notFound);
      }
      if (status == 409) {
        return ConflictFailure(errorMessage ?? ErrorMessages.conflict);
      }
      if (status == 422) {
        return ValidationFailure(errorMessage ?? ErrorMessages.validation);
      }
      if (status >= 500) {
        return ServerFailure(errorMessage ?? ErrorMessages.server);
      }
      return ServerFailure(
        errorMessage ?? response.statusMessage ?? ErrorMessages.server,
      );
    }

    // Fallback for unknown Dio errors
    return const UnexpectedFailure();
  }

  // Socket issues
  if (exception is SocketException) return const NetworkFailure();

  // Timeout from dart:async
  if (exception is TimeoutException) return const TimeoutFailure();

  // Default fallback
  return UnexpectedFailure(exception.toString());
}

/*
|--------------------------------------------------------------------------
|  Error Handling Layer – Exceptions & Failures
|--------------------------------------------------------------------------
| This module standardizes how all runtime and API errors are handled in
| your clean architecture app. It separates *low-level exceptions* (data
| layer) from *domain-level failures* (use case & presentation layers).
|
| Purpose:
|   - Convert technical exceptions (e.g., Dio, SocketException)
|     into meaningful, user-facing Failure objects.
|   - Maintain a consistent error flow across all layers.
|   - Keep repositories, Cubits, and UseCases clean and predictable.
|
| Structure:
| -------------------------------------------------------------------------
| exceptions.dart  →  Defines technical exceptions (ServerException, etc.)
| failures.dart    →  Maps exceptions into Failures for domain/UI layers.
| error_messages.dart → Central place for all error text messages.
| -------------------------------------------------------------------------
|
| Typical Usage:
|
| --- In a Repository ---
| try {
|   final response = await dio.get('/users');
|   return Right(UserModel.fromJson(response.data));
| } catch (error) {
|   final failure = mapExceptionToFailure(error);
|   return Left(failure);
| }
|
| --- In a Bloc or Cubit ---
| final result = await repository.getUser();
| result.fold(
|   (failure) => emit(UserError(failure.message)),
|   (user) => emit(UserLoaded(user)),
| );
|
| --- When Throwing Custom Exceptions ---
| throw ServerException('Failed to fetch user data');
| throw NetworkException('No Internet Connection');
|
| --- When Catching Dio Errors ---
| on DioException catch (e) {
|   throw fromDioException(e);
| }
|
| Benefits:
| - Centralized mapping for all Dio, Socket, Cache, and Timeout errors.
| - User-safe and localizable error messages.
| - Ready for integration with Either<L, R> and Bloc/Cubit layers.
| - Fully extendable: Add new exception/failure types easily.
|
| Example extension:
| -------------------------------------------------------------------------
| class PaymentException extends AppException { ... }
| class PaymentFailure extends Failure { ... }
| -------------------------------------------------------------------------
*/
