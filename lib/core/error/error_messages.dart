class ErrorMessages {
  // Server & Network
  static const String server = 'Something went wrong on the server. Please try again later.';
  static const String network = 'No internet connection. Please check your connection and try again.';
  static const String timeout = 'The request took too long. Please try again later.';
  static const String cancelled = 'The request was cancelled before completion.';

  // Auth & Access
  static const String unauthorized = 'You are not authorized. Please log in again.';
  static const String forbidden = 'Access denied. You do not have permission to perform this action.';

  // Client & Validation
  static const String validation = 'Some fields are invalid. Please review your input.';
  static const String badRequest = 'Invalid request. Please check your input and try again.';
  static const String conflict = 'A data conflict occurred. Please refresh and try again.';
  static const String notFound = 'Requested resource was not found.';

  // Cache & Local
  static const String cache = 'Unable to load saved data. Please try again later.';

  // Generic
  static const String unexpected = 'An unexpected error occurred. Please try again.';
}
