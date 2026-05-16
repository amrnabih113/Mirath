class AppException implements Exception {
  final String message;
  AppException(this.message);
  @override
  String toString() => 'AppException: $message';
}

class NetworkException extends AppException {
  NetworkException(String message) : super(message);
}

class UnauthorizedException extends AppException {
  UnauthorizedException(String message) : super(message);
}

class ServerException extends AppException {
  ServerException(String message) : super(message);
}

class ParsingException extends AppException {
  ParsingException(String message) : super(message);
}
