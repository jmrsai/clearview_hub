/*
 * Copyright 2026 ClearView Hub Contributors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/services/gemini_service.dart';
import '../../core/services/audit_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/translator_service.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  ChatMessage({required this.text, required this.isUser, required this.timestamp});
}

class GeminiChatScreen extends StatefulWidget {
  final String? initialPrompt;
  const GeminiChatScreen({super.key, this.initialPrompt});

  @override
  State<GeminiChatScreen> createState() => _GeminiChatScreenState();
}

class _GeminiChatScreenState extends State<GeminiChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  final List<String> _quickPrompts = [
    '👁️ What are symptoms of glaucoma?',
    '💊 Explain LASIK surgery recovery',
    '🔍 Check these eye symptoms: blurry vision, floaters',
    '🏥 Pre-op checklist for cataract surgery',
    '🌡️ How to manage dry eyes at home?',
    '⚠️ When to visit emergency for eye pain?',
  ];

  @override
  void initState() {
    super.initState();
    GeminiService.instance.initialize();
    _addWelcome();
    if (widget.initialPrompt != null) {
      Future.delayed(const Duration(milliseconds: 500), () => _send(widget.initialPrompt!));
    }
  }

  void _addWelcome() {
    _messages.add(ChatMessage(
      text: '👋 Hello! I\'m **ClearView MedAssist**, your AI medical companion.\n\n'
          'I specialize in:\n'
          '• 👁️ Eye conditions & ophthalmology\n'
          '• 💊 Medications & drug information\n'
          '• 🏥 Surgical preparation & recovery\n'
          '• 🔍 Symptom analysis & triage\n'
          '• 📋 Early disease detection tips\n\n'
          '*Always consult your doctor for final diagnosis.*',
      isUser: false,
      timestamp: DateTime.now(),
    ));
  }

  Future<void> _send(String text) async {
    if (text.trim().isEmpty) return;
    _controller.clear();
    HapticFeedback.lightImpact();

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true, timestamp: DateTime.now()));
      _isLoading = true;
    });
    _scrollToBottom();

    await AuditService.instance.logAction(action: 'AI_QUERY', resource: 'GEMINI_CHAT', details: text.length > 50 ? '${text.substring(0, 50)}...' : text);

    final response = await GeminiService.instance.sendMessage(text);
    
    // Translate response if needed
    final translated = await TranslatorService.instance.translate(response);

    if (mounted) {
      setState(() {
        _messages.add(ChatMessage(text: translated, isUser: false, timestamp: DateTime.now()));
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E1A),
        title: Row(children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.medical_services, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('MedAssist AI', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
            Text('Powered by Gemini', style: TextStyle(fontSize: 11, color: AppColors.cyan)),
          ]),
        ]),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white70),
            onPressed: () {
              GeminiService.instance.resetChat();
              setState(() { _messages.clear(); _addWelcome(); });
            },
          ),
        ],
      ),
      body: Column(children: [
        // Quick prompt chips
        SizedBox(
          height: 44,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _quickPrompts.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (_, i) => ActionChip(
              label: Text(_quickPrompts[i], style: const TextStyle(fontSize: 12, color: Colors.white)),
              backgroundColor: const Color(0xFF1E2235),
              side: BorderSide(color: AppColors.cyan.withAlpha(60)),
              onPressed: () => _send(_quickPrompts[i]),
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Messages
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _messages.length + (_isLoading ? 1 : 0),
            itemBuilder: (_, i) {
              if (_isLoading && i == _messages.length) return _TypingIndicator();
              final msg = _messages[i];
              return _MessageBubble(message: msg);
            },
          ),
        ),
        // Input bar
        Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          decoration: BoxDecoration(
            color: const Color(0xFF10142A),
            border: Border(top: BorderSide(color: AppColors.cyan.withAlpha(30))),
          ),
          child: Row(children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2235),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.cyan.withAlpha(40)),
                ),
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(color: Colors.white),
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    hintText: 'Ask me about your health...',
                    hintStyle: TextStyle(color: Colors.white38),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  ),
                  onSubmitted: _send,
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () => _send(_controller.text),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(gradient: AppColors.primaryGradient, shape: BoxShape.circle),
                child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              margin: const EdgeInsets.only(right: 8, top: 4),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(gradient: AppColors.primaryGradient, shape: BoxShape.circle),
              child: const Icon(Icons.medical_services, color: Colors.white, size: 14),
            ),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: isUser
                    ? const LinearGradient(colors: [Color(0xFF0EA5E9), Color(0xFF2563EB)])
                    : null,
                color: isUser ? null : const Color(0xFF1E2235),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isUser ? 18 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 18),
                ),
                border: isUser ? null : Border.all(color: AppColors.cyan.withAlpha(30)),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.5,
                  fontWeight: isUser ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
            ),
          ),
          if (isUser) const SizedBox(width: 8),
        ],
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(gradient: AppColors.primaryGradient, shape: BoxShape.circle),
        child: const Icon(Icons.medical_services, color: Colors.white, size: 14),
      ),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(color: const Color(0xFF1E2235), borderRadius: BorderRadius.circular(18)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          _Dot(delay: 0),
          const SizedBox(width: 4),
          _Dot(delay: 200),
          const SizedBox(width: 4),
          _Dot(delay: 400),
        ]),
      ),
    ]);
  }
}

class _Dot extends StatefulWidget {
  final int delay;
  const _Dot({required this.delay});
  @override
  State<_Dot> createState() => _DotState();
}

class _DotState extends State<_Dot> with SingleTickerProviderStateMixin {
  late AnimationController _c;
  late Animation<double> _a;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 600))..repeat(reverse: true);
    _a = CurvedAnimation(parent: _c, curve: Curves.easeInOut);
    Future.delayed(Duration(milliseconds: widget.delay), () { if (mounted) _c.forward(); });
  }

  @override
  void dispose() { _c.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => FadeTransition(
    opacity: _a,
    child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.cyan, shape: BoxShape.circle)),
  );
}
