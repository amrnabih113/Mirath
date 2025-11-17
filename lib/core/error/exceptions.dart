import 'dart:io';

import 'package:dio/dio.dart';

/// Simple, descriptive exception types used within the data layer.
/// Each exception carries an optional message, HTTP status code and extra data.
class ServerException implements Exception {
  final String? message;
  final int? statusCode;
  final dynamic data;
  ServerException([this.message, this.statusCode, this.data]);

  @override
  String toString() => 'ServerException(${statusCode ?? ''}): ${message ?? ''}';
}

class CacheException implements Exception {
  final String? message;
  final dynamic data;
  CacheException([this.message, this.data]);

  @override
  String toString() => 'CacheException: ${message ?? ''}';
}

class NetworkException implements Exception {
  final String? message;
  NetworkException([this.message]);

  @override
  String toString() => 'NetworkException: ${message ?? ''}';
}

class TimeoutException implements Exception {
  final String? message;
  TimeoutException([this.message]);

  @override
  String toString() => 'TimeoutException: ${message ?? ''}';
}

class UnauthorizedException implements Exception {
  final String? message;
  UnauthorizedException([this.message]);

  @override
  String toString() => 'UnauthorizedException: ${message ?? ''}';
}

class ValidationException implements Exception {
  final String? message;
  final dynamic errors;
  ValidationException([this.message, this.errors]);

  @override
  String toString() => 'ValidationException: ${message ?? ''}';
}

class NotFoundException implements Exception {
  final String? message;
  NotFoundException([this.message]);

  @override
  String toString() => 'NotFoundException: ${message ?? ''}';
}

class ConflictException implements Exception {
  final String? message;
  ConflictException([this.message]);

  @override
  String toString() => 'ConflictException: ${message ?? ''}';
}

class UnexpectedException implements Exception {
  final String? message;
  UnexpectedException([this.message]);

  @override
  String toString() => 'UnexpectedException: ${message ?? ''}';
}

/// Create a domain exception from a Dio error. This centralises the mapping logic
/// so callers can convert transport-layer errors into meaningful exceptions.
Exception fromDioException(DioException dio) {
  // Timeout / cancelled
  final typeStr = dio.type.toString().toLowerCase();
  if (typeStr.contains('cancel')) {
    return UnexpectedException('Request cancelled');
  }
  if (typeStr.contains('timeout')) return TimeoutException('Request timeout');

  // Network
  if (dio.error is SocketException) return NetworkException('No Internet');

  final resp = dio.response;
  if (resp != null) {
    final status = resp.statusCode ?? 0;
    final msg = resp.statusMessage ?? resp.data?.toString();
    if (status == 401) return UnauthorizedException(msg);
    if (status == 403) return UnauthorizedException(msg);
    if (status == 404) return NotFoundException(msg);
    if (status == 409) return ConflictException(msg);
    if (status == 422) return ValidationException(msg, resp.data);
    if (status >= 500) return ServerException(msg, status, resp.data);
    return ServerException(msg, status, resp.data);
  }

  return UnexpectedException(dio.message);
}

