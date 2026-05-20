import 'package:supabase_flutter/supabase_flutter.dart';
import 'sync_queue_service.dart';

class ClinicalDataService {
  final SupabaseClient _client;
  final SyncQueueService _syncQueue;

  ClinicalDataService(this._client, this._syncQueue);

  /// Save an eye test result using the offline-first queue
  Future<void> saveEyeTest({
    required String testType,
    required Map<String, dynamic> results,
    double? visionScore,
    String? eye,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final payload = {
      'patient_id': user.id,
      'test_type': testType,
      'results': results,
      'vision_score': visionScore,
      'eye': eye,
    };

    // Use SyncQueue to handle offline capabilities
    await _syncQueue.enqueueMutation(
      table: 'eye_tests',
      action: 'insert',
      payload: payload,
    );
  }

  /// Fetch eye test history (prioritizes remote, could cache locally in the future)
  Future<List<Map<String, dynamic>>> getEyeTestHistory() async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    return await _client
        .from('eye_tests')
        .select()
        .eq('patient_id', user.id)
        .order('created_at', ascending: false);
  }

  /// Update patient medical history using offline-first queue
  Future<void> updateMedicalHistory(Map<String, dynamic> history) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final payload = {
      'id': user.id, // ID is required for 'update' action in SyncQueue
      'medical_history': history,
    };

    await _syncQueue.enqueueMutation(
      table: 'patients',
      action: 'update',
      payload: payload,
    );
  }

  /// Fetch complete patient profile (EHR)
  Future<Map<String, dynamic>> getPatientProfile() async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    return await _client
        .from('profiles')
        .select('*, patients(*)')
        .eq('id', user.id)
        .single();
  }
}
