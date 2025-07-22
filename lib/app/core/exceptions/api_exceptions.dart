// API Exception Classes

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => 'ApiException: $message';
}

class NetworkException extends ApiException {
  NetworkException(super.message);

  @override
  String toString() => 'NetworkException: $message';
}

class BadRequestException extends ApiException {
  BadRequestException(String message) : super(message, 400);

  @override
  String toString() => 'BadRequestException: $message';
}

class UnauthorizedException extends ApiException {
  UnauthorizedException(String message) : super(message, 401);

  @override
  String toString() => 'UnauthorizedException: $message';
}

class ForbiddenException extends ApiException {
  ForbiddenException(String message) : super(message, 403);

  @override
  String toString() => 'ForbiddenException: $message';
}

class NotFoundException extends ApiException {
  NotFoundException(String message) : super(message, 404);

  @override
  String toString() => 'NotFoundException: $message';
}

class ValidationException extends ApiException {
  final dynamic validationErrors;

  ValidationException(String message, [this.validationErrors]) : super(message, 422);

  @override
  String toString() => 'ValidationException: $message';
}

class ServerException extends ApiException {
  ServerException(String message) : super(message, 500);

  @override
  String toString() => 'ServerException: $message';
}
