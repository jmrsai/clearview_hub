import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

/// Interceptor to log network requests and responses for debugging.
/// Ensure this is disabled or stripped in production builds for security.
class LoggingInterceptor extends Interceptor {
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 80,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.none,
    ),
  );

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logger.i('REQUEST[${options.method}] => PATH: ${options.path}\nHEADERS: ${options.headers}\nDATA: ${options.data}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _logger.i('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}\nDATA: ${response.data}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.e('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}\nMESSAGE: ${err.message}');
    super.onError(err, handler);
  }
}
