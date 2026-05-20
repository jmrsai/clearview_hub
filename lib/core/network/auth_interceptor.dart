import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Interceptor to automatically attach the Supabase JWT token to outgoing API requests.
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Attempt to get the current Supabase session
    final session = Supabase.instance.client.auth.currentSession;
    
    if (session != null && session.accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer ${session.accessToken}';
    }
    
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle 401 Unauthorized globally here if needed (e.g., force logout)
    if (err.response?.statusCode == 401) {
      // Trigger logout or token refresh logic
    }
    super.onError(err, handler);
  }
}
