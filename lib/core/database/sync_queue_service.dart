import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logger/logger.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Represents a mutation operation that needs to be synced with the remote server.
class SyncMutation {
  final String id;
  final String table;
  final String action; // 'insert', 'update', 'delete'
  final Map<String, dynamic> payload;
  final DateTime timestamp;

  SyncMutation({
    required this.id,
    required this.table,
    required this.action,
    required this.payload,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'table': table,
      'action': action,
      'payload': payload,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory SyncMutation.fromMap(Map<dynamic, dynamic> map) {
    return SyncMutation(
      id: map['id'],
      table: map['table'],
      action: map['action'],
      payload: Map<String, dynamic>.from(map['payload']),
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}

/// Offline-First Synchronization Queue.
/// Queues mutations locally when offline and pushes them to Supabase when online.
class SyncQueueService {
  static const String _syncQueueBoxName = 'offline_sync_queue';
  final SupabaseClient _supabase;
  final Logger _logger = Logger();
  late Box _queueBox;

  SyncQueueService(this._supabase);

  Future<void> init() async {
    _queueBox = await Hive.openBox(_syncQueueBoxName);
    
    // Listen to network changes to trigger sync
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      if (results.contains(ConnectivityResult.mobile) || results.contains(ConnectivityResult.wifi)) {
        processQueue();
      }
    });
  }

  /// Add a mutation to the queue (e.g., when a user saves a Vision Test)
  Future<void> enqueueMutation({
    required String table,
    required String action,
    required Map<String, dynamic> payload,
  }) async {
    final mutation = SyncMutation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      table: table,
      action: action,
      payload: payload,
      timestamp: DateTime.now(),
    );

    await _queueBox.put(mutation.id, mutation.toMap());
    _logger.i('Queued mutation for table $table: ${mutation.id}');
    
    // Attempt to process immediately if online
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.mobile) || connectivityResult.contains(ConnectivityResult.wifi)) {
      processQueue();
    }
  }

  /// Process the queue by sending mutations to Supabase
  Future<void> processQueue() async {
    if (_queueBox.isEmpty) return;
    
    _logger.i('Processing sync queue with ${_queueBox.length} items...');

    final keys = _queueBox.keys.toList();
    for (var key in keys) {
      try {
        final rawData = _queueBox.get(key);
        if (rawData == null) continue;

        final mutation = SyncMutation.fromMap(rawData);
        await _executeRemoteMutation(mutation);
        
        // Remove from queue on success
        await _queueBox.delete(key);
        _logger.i('Successfully synced mutation ${mutation.id}');
      } catch (e) {
        _logger.e('Failed to sync mutation $key: $e');
        // Stop processing on first error to maintain sequential integrity
        break; 
      }
    }
  }

  Future<void> _executeRemoteMutation(SyncMutation mutation) async {
    final builder = _supabase.from(mutation.table);
    
    switch (mutation.action) {
      case 'insert':
        await builder.insert(mutation.payload);
        break;
      case 'update':
        if (!mutation.payload.containsKey('id')) {
          throw Exception('Update mutation requires an "id" in the payload');
        }
        await builder.update(mutation.payload).eq('id', mutation.payload['id']);
        break;
      case 'delete':
        if (!mutation.payload.containsKey('id')) {
          throw Exception('Delete mutation requires an "id" in the payload');
        }
        await builder.delete().eq('id', mutation.payload['id']);
        break;
      default:
        throw Exception('Unknown action: ${mutation.action}');
    }
  }
}
