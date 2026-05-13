import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  static final ChatService _instance = ChatService._internal();
  factory ChatService() => _instance;
  ChatService._internal();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Send a message in a specific chat room
  Future<void> sendMessage(String roomId, ChatMessage message) async {
    await _db.collection('chats').doc(roomId).collection('messages').add(
          message.toJson(),
        );
    
    // Update last message in the room for the dashboard
    await _db.collection('chats').doc(roomId).set({
      'lastMessage': message.text,
      'lastTimestamp': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Stream messages for a specific chat room
  Stream<List<ChatMessage>> getMessages(String roomId) {
    return _db
        .collection('chats')
        .doc(roomId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatMessage.fromJson(doc.data()))
            .toList());
  }

  /// Create or get a chat room between two users
  Future<String> getRoomId(String otherUserId) async {
    final currentUserId = _auth.currentUser!.uid;
    List<String> ids = [currentUserId, otherUserId]..sort();
    String roomId = ids.join('_');
    return roomId;
  }
}
