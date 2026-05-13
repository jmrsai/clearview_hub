import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MedicalPost {
  final String id;
  final String authorId;
  final String authorName;
  final String content;
  final DateTime timestamp;
  final List<String> likes;
  final int commentCount;

  MedicalPost({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.content,
    required this.timestamp,
    required this.likes,
    required this.commentCount,
  });

  factory MedicalPost.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return MedicalPost(
      id: doc.id,
      authorId: data['authorId'] ?? '',
      authorName: data['authorName'] ?? 'Anonymous',
      content: data['content'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      likes: List<String>.from(data['likes'] ?? []),
      commentCount: data['commentCount'] ?? 0,
    );
  }
}

class CommunityService {
  static final CommunityService _instance = CommunityService._internal();
  factory CommunityService() => _instance;
  CommunityService._internal();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Create a new medical information post
  Future<void> createPost(String content) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _db.collection('community_posts').add({
      'authorId': user.uid,
      'authorName': user.displayName ?? 'Doctor',
      'content': content,
      'timestamp': FieldValue.serverTimestamp(),
      'likes': [],
      'commentCount': 0,
    });
  }

  /// Get a stream of the latest medical information
  Stream<List<MedicalPost>> getLatestInformation() {
    return _db
        .collection('community_posts')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => MedicalPost.fromFirestore(doc)).toList());
  }

  /// Like a post
  Future<void> likePost(String postId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    await _db.collection('community_posts').doc(postId).update({
      'likes': FieldValue.arrayUnion([userId]),
    });
  }
}
