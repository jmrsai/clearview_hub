import '../entities/community.dart';
import '../entities/community_post.dart';

abstract class CommunityRepository {
  Future<List<Community>> getCommunities({String? category});
  Future<List<CommunityPost>> getPosts({String? communityId, int limit = 20, int offset = 0});
  Future<CommunityPost> createPost(CommunityPost post);
  Future<void> reactToPost(String postId, String reactionType);
  Future<void> deletePost(String postId);
  
  // Realtime
  Stream<List<CommunityPost>> watchPosts(String communityId);
}
