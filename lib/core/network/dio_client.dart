import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_interceptor.dart';
import 'logging_interceptor.dart';

/// Global Provider for the Dio Client.
final dioProvider = Provider<Dio>((ref) {
  final dio = DioClient.getInstance();
  // We can attach the auth interceptor here, reading auth tokens securely.
  dio.interceptors.add(AuthInterceptor());
  dio.interceptors.add(LoggingInterceptor());
  return dio;
});

class DioClient {
  static const String baseUrl = 'https://api.eyeverse.ai/v1'; // Example production URL
  static const int connectTimeout = 15000; // 15 seconds
  static const int receiveTimeout = 15000;

  static Dio getInstance() {
    final options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(milliseconds: connectTimeout),
      receiveTimeout: const Duration(milliseconds: receiveTimeout),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        // Defensive Security Headers
        'X-Content-Type-Options': 'nosniff',
        'X-XSS-Protection': '1; mode=block',
        'Strict-Transport-Security': 'max-age=31536000; includeSubDomains; preload',
      },
    );

    final dio = Dio(options);
    
    // In a production environment, implement SSL Certificate Pinning here
    // to thwart Man-In-The-Middle (MITM) attacks.
    // Example using dio_http2_adapter or native pinning configurations.
    
    return dio;
  }
}
