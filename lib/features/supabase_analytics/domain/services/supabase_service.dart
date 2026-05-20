import 'package:supabase_flutter/supabase_flutter.dart';

class CloudAnalyticsService {
  final _supabase = Supabase.instance.client;

  /// Uploads aggregated health analytics.
  /// Data is anonymized before upload to maintain primary offline-first privacy.
  Future<void> syncAnalytics(Map<String, dynamic> localData) async {
    try {
      // 1. Filter only aggregated metrics (no PII)
      final aggregated = {
        'avg_score': localData['avg_score'],
        'top_trigger': localData['top_trigger'],
        'weekly_improvement': localData['improvement_delta'],
        'sync_timestamp': DateTime.now().toIso8601String(),
      };

      // 2. Perform upsert into Supabase
      await _supabase.from('health_analytics').insert(aggregated);
    } catch (e) {
      // Offline-first: silently ignore if sync fails
    }
  }

  /// Fetches community-wide trends for benchmarking.
  Future<List<dynamic>> getGlobalTrends() async {
    try {
      final response = await _supabase
          .from('health_analytics')
          .select('avg_score, top_trigger')
          .limit(10);
      return response as List<dynamic>;
    } catch (e) {
      return [];
    }
  }
}
