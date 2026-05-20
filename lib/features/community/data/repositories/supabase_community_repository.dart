import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/community.dart';
import '../../domain/entities/community_post.dart';
import '../../domain/repositories/community_repository.dart';

class SupabaseCommunityRepository implements CommunityRepository {
  final SupabaseClient _client;

  SupabaseCommunityRepository(this._client);

  @override
  Future<List<Community>> getCommunities({String? category}) async {
    var query = _client.from('communities').select();
    
    if (category != null) {
      query = query.eq('category', category);
    }
    
    final response = await query.order('member_count', ascending: false);
    return (response as List).map((json) => Community.fromJson(json)).toList();
  }

  @override
  Future<List<CommunityPost>> getPosts({
    String? communityId, 
    int limit = 20, 
    int offset = 0
  }) async {
    var query = _client.from('community_posts').select('''
      *,
      author:profiles(full_name, avatar_url)
    ''');
    
    if (communityId != null) {
      query = query.eq('community_id', communityId);
    }
    
    final response = await query
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);

    return (response as List).map((json) {
      final post = CommunityPost.fromJson(json);
      // Map Joined Author Data
      if (json['is_anonymous'] == true) {
        return post.copyWith(authorName: 'Anonymous', authorAvatarUrl: null);
      }
      return post.copyWith(
        authorName: json['author']['full_name'],
        authorAvatarUrl: json['author']['avatar_url'],
      );
    }).toList();
  }

  @override
  Future<CommunityPost> createPost(CommunityPost post) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Unauthorized');

    final payload = post.toJson()
      ..remove('id')
      ..remove('authorName')
      ..remove('authorAvatarUrl')
      ..remove('isUpvotedByMe')
      ..remove('isDownvotedByMe')
      ..['author_id'] = user.id;

    final response = await _client
        .from('community_posts')
        .insert(payload)
        .select()
        .single();

    return CommunityPost.fromJson(response);
  }

  @override
  Future<void> reactToPost(String postId, String reactionType) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Unauthorized');

    await _client.from('community_reactions').upsert({
      'user_id': user.id,
      'post_id': postId,
      'reaction_type': reactionType,
    });
  }

  @override
  Future<void> deletePost(String postId) async {
    await _client.from('community_posts').delete().eq('id', postId);
  }

  @override
  Stream<List<CommunityPost>> watchPosts(String communityId) {
    return _client
        .from('community_posts')
        .stream(primaryKey: ['id'])
        .eq('community_id', communityId)
        .order('created_at')
        .map((data) => data.map((json) => CommunityPost.fromJson(json)).toList());
  }
}
