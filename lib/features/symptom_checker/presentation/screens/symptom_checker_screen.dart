import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

class SymptomCheckerScreen extends StatefulWidget {
  const SymptomCheckerScreen({super.key});

  @override
  State<SymptomCheckerScreen> createState() => _SymptomCheckerScreenState();
}

class _SymptomCheckerScreenState extends State<SymptomCheckerScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'isUser': false,
      'text':
          'Hello! I am your EyeVerse AI Assistant. Please describe any symptoms you are experiencing with your eyes (e.g., redness, pain, blurry vision). \n\n*Disclaimer: I am an AI, not a doctor. In an emergency, please visit a hospital immediately.*',
    },
  ];
  bool _isTyping = false;

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final userText = _messageController.text;
    setState(() {
      _messages.add({'isUser': true, 'text': userText});
      _isTyping = true;
    });
    _messageController.clear();

    // Mock AI delay
    await Future.delayed(const Duration(seconds: 2));

    // Mock Triage logic
    String aiResponse = '';
    if (userText.toLowerCase().contains('pain') &&
        userText.toLowerCase().contains('sudden')) {
      aiResponse =
          '⚠️ **EMERGENCY DETECTED**\nSudden eye pain can be a sign of a serious condition like acute glaucoma. Please seek immediate medical attention.';
    } else if (userText.toLowerCase().contains('red') ||
        userText.toLowerCase().contains('itchy')) {
      aiResponse =
          'Based on your symptoms (redness/itchiness), you might have conjunctivitis (pink eye) or dry eyes. Try avoiding screen time and using artificial tears. If symptoms persist for more than 48 hours, consult a specialist.';
    } else {
      aiResponse =
          'Thank you for sharing. Could you provide more details? Are you experiencing any light sensitivity or changes in your vision?';
    }

    if (mounted) {
      setState(() {
        _isTyping = false;
        _messages.add({'isUser': false, 'text': aiResponse});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Symptom Checker'),
        actions: [
          IconButton(icon: const Icon(Icons.info_outline), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // Emergency Banner (Mock)
          Container(
            color: AppColors.error.withValues(alpha: 0.1),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.warning, color: AppColors.error, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'For sudden vision loss or severe trauma, call emergency services.',
                    style: TextStyle(
                      color: AppColors.error.withValues(alpha: 0.9),
                      fontSize: 12,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => context.push('/emergency'),
                  child: const Text(
                    'SOS',
                    style: TextStyle(
                      color: AppColors.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _buildChatBubble(msg['text'], msg['isUser']);
              },
            ),
          ),

          if (_isTyping)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'AI is typing...',
                  style: TextStyle(
                    color: Colors.white54,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              border: Border(
                top: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.mic, color: AppColors.accent),
                    onPressed: () {
                      // TODO: Implement speech-to-text
                    },
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Describe your symptoms...',
                        hintStyle: const TextStyle(color: Colors.white54),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.05),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: AppColors.secondary,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble(String text, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isUser
              ? AppColors.primary
              : Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isUser ? 20 : 0),
            bottomRight: Radius.circular(isUser ? 0 : 20),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 15),
        ),
      ),
    );
  }
}
