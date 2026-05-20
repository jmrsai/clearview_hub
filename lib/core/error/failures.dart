import 'package:equatable/equatable.dart';

/// Base class for handling failures across the application
abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object> get props => [message];
}

// General failures
class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure({required String message, this.statusCode}) : super(message: message);

  @override
  List<Object> get props => [message, if (statusCode != null) statusCode!];
}

class CacheFailure extends Failure {
  const CacheFailure({required String message}) : super(message: message);
}

class NetworkFailure extends Failure {
  const NetworkFailure({String message = 'Please check your internet connection.'}) : super(message: message);
}

class AuthFailure extends Failure {
  const AuthFailure({required String message}) : super(message: message);
}
