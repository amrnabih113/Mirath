/// Translates technical errors into user-friendly messages
class ErrorMessageTranslator {
  /// Translate network/socket errors
  static String translateNetworkError(String originalError) {
    final error = originalError.toLowerCase();

    if (error.contains('socket')) {
      return 'Connection lost. Check your internet and try again.';
    }
    if (error.contains('timeout')) {
      return 'Request timed out. Please try again.';
    }
    if (error.contains('dio') || error.contains('400')) {
      return 'Failed to send message. Please try again.';
    }
    if (error.contains('401') || error.contains('unauthorized')) {
      return 'Your session has expired. Please log in again.';
    }
    if (error.contains('403') || error.contains('forbidden')) {
      return 'You do not have permission to access this conversation.';
    }
    if (error.contains('404') || error.contains('not found')) {
      return 'This conversation is no longer available.';
    }
    if (error.contains('500') || error.contains('server error')) {
      return 'Server error. Please try again later.';
    }
    if (error.contains('503')) {
      return 'Service unavailable. Please try again later.';
    }

    return 'An error occurred. Please try again.';
  }

  /// Translate stream-specific errors
  static String translateStreamError(String originalError) {
    final error = originalError.toLowerCase();

    if (error.contains('closed')) {
      return 'Connection was interrupted. Tap retry to continue.';
    }
    if (error.contains('timeout')) {
      return 'Response took too long. Please try again.';
    }
    if (error.contains('parse')) {
      return 'Failed to process response. Please try again.';
    }

    return translateNetworkError(originalError);
  }

  /// Translate upload errors
  static String translateUploadError(String originalError) {
    final error = originalError.toLowerCase();

    if (error.contains('size')) {
      return 'File is too large. Maximum size is 25MB.';
    }
    if (error.contains('type')) {
      return 'File type not supported.';
    }
    if (error.contains('corrupt')) {
      return 'File appears to be corrupted.';
    }

    return translateNetworkError(originalError);
  }

  /// Translate API-specific errors
  static String translateApiError(String errorCode, String? message) {
    switch (errorCode) {
      case 'SESSION_EXPIRED':
        return 'This conversation has expired. Start a new chat.';
      case 'SESSION_NOT_FOUND':
        return 'This conversation is no longer available.';
      case 'UNAUTHORIZED':
        return 'Please log in to continue.';
      case 'RATE_LIMITED':
        return 'Too many requests. Please wait a moment.';
      case 'INVALID_INPUT':
        return 'Message format is invalid. Please try again.';
      case 'FILE_TOO_LARGE':
        return 'File is too large. Maximum size is 25MB.';
      case 'UNSUPPORTED_FILE_TYPE':
        return 'This file type is not supported.';
      case 'TRANSCRIPTION_FAILED':
        return 'Failed to transcribe audio. Please try again.';
      case 'GENERATION_FAILED':
        return 'Failed to generate response. Please try again.';
      case 'KNOWLEDGE_BASE_ERROR':
        return 'Could not search knowledge base. Please try again.';
      default:
        return message ?? 'An error occurred. Please try again.';
    }
  }

  /// Check if error is recoverable with retry
  static bool isRecoverable(String errorCode) {
    const recoverableErrors = {
      'TIMEOUT',
      'SOCKET_EXCEPTION',
      'CONNECTION_RESET',
      'BROKEN_PIPE',
      'RATE_LIMITED',
      'TEMPORARILY_UNAVAILABLE',
      'STREAM_CLOSED',
      'GENERATION_FAILED', // Can retry generation
      'TRANSCRIPTION_FAILED', // Can retry
    };

    return recoverableErrors.any((e) => errorCode.toUpperCase().contains(e));
  }

  /// Get retry suggestion text
  static String getRetrySuggestion(String errorCode) {
    if (errorCode.contains('RATE_LIMITED')) {
      return 'Please wait a moment before retrying.';
    }
    if (errorCode.contains('TIMEOUT')) {
      return 'The server is taking longer than expected. Retry or try again later.';
    }
    if (errorCode.contains('SESSION')) {
      return 'Start a new conversation to continue.';
    }
    return 'Tap "Retry" to try again.';
  }

  /// Format user-friendly error message with action
  static String formatErrorWithAction(String error, {bool canRetry = true}) {
    final translated = translateNetworkError(error);
    if (!canRetry) return translated;
    return '$translated\n\nTap Retry to try again.';
  }
}

/// Helper to categorize errors for analytics
enum ErrorCategory {
  network,
  authentication,
  validation,
  server,
  upload,
  generation,
  unknown,
}

/// Categorize error for tracking
ErrorCategory categorizeError(String error) {
  final lower = error.toLowerCase();

  if (lower.contains('socket') || lower.contains('timeout')) {
    return ErrorCategory.network;
  }
  if (lower.contains('401') || lower.contains('unauthorized')) {
    return ErrorCategory.authentication;
  }
  if (lower.contains('400') || lower.contains('parse')) {
    return ErrorCategory.validation;
  }
  if (lower.contains('500') || lower.contains('503')) {
    return ErrorCategory.server;
  }
  if (lower.contains('size') || lower.contains('type')) {
    return ErrorCategory.upload;
  }
  if (lower.contains('generation') || lower.contains('response')) {
    return ErrorCategory.generation;
  }

  return ErrorCategory.unknown;
}
