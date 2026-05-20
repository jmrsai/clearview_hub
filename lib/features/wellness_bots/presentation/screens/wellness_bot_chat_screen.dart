import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/services/wellness_bot_service.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class WellnessBotChatScreen extends ConsumerStatefulWidget {
  final WellnessBot bot;
  const WellnessBotChatScreen({super.key, required this.bot});

  @override
  ConsumerState<WellnessBotChatScreen> createState() =>
      _WellnessBotChatScreenState();
}

class _WellnessBotChatScreenState extends ConsumerState<WellnessBotChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    // Bot greeting
    _messages.add(
      ChatMessage(
        text: 'Hello! I am ${widget.bot.name}. ${widget.bot.description}',
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
  }

  void _sendMessage() {
    if (_controller.text.isEmpty) return;

    final userText = _controller.text;
    setState(() {
      _messages.add(
        ChatMessage(text: userText, isUser: true, timestamp: DateTime.now()),
      );
      _controller.clear();
    });

    // Simulate bot response
    Future.delayed(const Duration(seconds: 1), () {
      final botService = ref.read(wellnessBotServiceProvider);
      final response = botService.getAutomatedReminder(
        widget.bot.type,
        detectedMood: 'normal',
      );

      if (mounted) {
        setState(() {
          _messages.add(
            ChatMessage(
              text: response,
              isUser: false,
              timestamp: DateTime.now(),
            ),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.blueAccent.withValues(alpha: 0.2),
              child: const Icon(
                Icons.smart_toy,
                size: 20,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.bot.name, style: const TextStyle(fontSize: 16)),
                Text(
                  'online',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.greenAccent.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: const Color(0xFF0F3460),
      ),
      body: Column(
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
    );
  }

  Widget _buildMessageBubble(ChatMessage msg) {
    return Align(
      alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: msg.isUser ? const Color(0xFFE94560) : const Color(0xFF16213E),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(15),
            topRight: const Radius.circular(15),
            bottomLeft: Radius.circular(msg.isUser ? 15 : 0),
            bottomRight: Radius.circular(msg.isUser ? 0 : 15),
          ),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Text(msg.text, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(8),
      color: const Color(0xFF1A1A2E),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.attach_file, color: Colors.blueAccent),
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Message...',
                hintStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                ),
                border: InputBorder.none,
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blueAccent),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
