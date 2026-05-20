import 'package:flutter/material.dart';
import '../../../../widgets/glass_card.dart';
import '../../domain/services/encryption_service.dart';

class EncryptedChatScreen extends StatefulWidget {
  final String peerName;
  final String peerAvatar;

  const EncryptedChatScreen({
    super.key,
    required this.peerName,
    required this.peerAvatar,
  });

  @override
  State<EncryptedChatScreen> createState() => _EncryptedChatScreenState();
}

class _EncryptedChatScreenState extends State<EncryptedChatScreen> {
  final SecureMessagingService _messagingService = SecureMessagingService();
  final TextEditingController _controller = TextEditingController();
  final List<_ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadMockHistory();
  }

  void _loadMockHistory() {
    _messages.add(
      _ChatMessage(
        text: 'Hello! This is a secure end-to-end encrypted session.',
        isMe: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
      ),
    );
    _messages.add(
      _ChatMessage(
        text: 'Your health data and messages are protected.',
        isMe: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 9)),
      ),
    );
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    final originalText = _controller.text;
    _controller.clear();

    // In a real app, we would encrypt before sending to the backend
    final encrypted = _messagingService.encryptMessage(originalText);
    debugPrint('E2EE Payload: $encrypted');

    setState(() {
      _messages.add(
        _ChatMessage(text: originalText, isMe: true, timestamp: DateTime.now()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(widget.peerAvatar),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.peerName, style: const TextStyle(fontSize: 16)),
                const Text(
                  '🔒 End-to-End Encrypted',
                  style: TextStyle(fontSize: 10, color: Colors.greenAccent),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.videocam), onPressed: () {}),
          IconButton(icon: const Icon(Icons.call), onPressed: () {}),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0A0E1A), Color(0xFF16213E)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[_messages.length - 1 - index];
                  return _buildMessageBubble(msg);
                },
              ),
            ),
            _buildInputArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(_ChatMessage msg) {
    return Align(
      alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: msg.isMe
              ? Colors.cyan.shade800
              : Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(msg.isMe ? 16 : 0),
            bottomRight: Radius.circular(msg.isMe ? 0 : 16),
          ),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              msg.text,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              '${msg.timestamp.hour}:${msg.timestamp.minute.toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 9, color: Colors.white38),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.cyan),
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: const InputDecoration(
                hintText: 'Message...',
                hintStyle: TextStyle(color: Colors.white30),
                border: InputBorder.none,
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.mic, color: Colors.cyan),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.cyan),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isMe;
  final DateTime timestamp;
  _ChatMessage({
    required this.text,
    required this.isMe,
    required this.timestamp,
  });
}
