/// Base class for all custom exceptions in the app
abstract class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException({required this.message, this.statusCode});
}

class CacheException implements Exception {
  final String message;

  CacheException({required this.message});
}

class NetworkException implements Exception {
  final String message;

  NetworkException({this.message = 'No internet connection available.'});
}

class UnauthorizedException extends ServerException {
  UnauthorizedException({String message = 'Unauthorized access.'}) 
      : super(message: message, statusCode: 401);
}

class ValidationException extends ServerException {
  ValidationException({required String message}) 
      : super(message: message, statusCode: 400);
}
