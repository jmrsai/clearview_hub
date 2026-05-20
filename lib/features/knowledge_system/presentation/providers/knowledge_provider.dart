import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/network/dio_client.dart';
import '../services/content_sync_service.dart';

final contentSyncServiceProvider = Provider<MedicalContentSyncService>((ref) {
  final dio = ref.watch(dioProvider);
  return MedicalContentSyncService(Supabase.instance.client, dio);
});

/// Semantic search results provider
final knowledgeSearchProvider = FutureProvider.family<List<dynamic>, String>((ref, query) async {
  final supabase = Supabase.instance.client;
  
  if (query.isEmpty) return [];

  // Semantic Search logic using Supabase RPC (which calls pgvector match_documents)
  // For now, falling back to a text-based keyword search across multiple ecosystem tables.
  final results = await supabase.rpc('search_ecosystem', params: {'search_query': query});
  
  return results as List<dynamic>;
});
