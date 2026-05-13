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
import '../../core/services/python_api_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';

class AiHealthChatbot extends StatefulWidget {
  const AiHealthChatbot({super.key});

  @override
  State<AiHealthChatbot> createState() => _AiHealthChatbotState();
}

class _AiHealthChatbotState extends State<AiHealthChatbot> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'isUser': false,
      'text': 'Hello! I am the ClearView MedOS AI. Describe any eye or general health symptoms you are experiencing.',
    }
  ];
  bool _isLoading = false;

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    
    setState(() {
      _messages.add({'isUser': true, 'text': text});
      _isLoading = true;
    });
    _controller.clear();

    try {
      // Use the centralized Python API Service
      final data = await PythonApiService.instance.chatMedical(text);

      setState(() {
        _messages.add({
          'isUser': false, 
          'text': data['response'],
          'isEmergency': data['is_emergency'] ?? false
        });
      });
    } catch (e) {
      // Fallback if Python backend is not running
      setState(() {
        _messages.add({
          'isUser': false,
          'text': 'The Python AI backend is currently offline. Please ensure the server is running on port 8000.',
          'isError': true
        });
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: AppBar(title: const Text('MedOS AI Assistant')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  final isUser = msg['isUser'];
                  final isError = msg['isError'] ?? false;
                  final isEmergency = msg['isEmergency'] ?? false;

                  return Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.75,
                      ),
                      decoration: BoxDecoration(
                        color: isUser 
                            ? AppColors.info.withValues(alpha: 0.8) 
                            : isError ? AppColors.error.withValues(alpha: 0.8) 
                            : AppColors.glassFill,
                        borderRadius: BorderRadius.circular(16).copyWith(
                          bottomRight: isUser ? Radius.zero : null,
                          bottomLeft: !isUser ? Radius.zero : null,
                        ),
                        border: isUser ? null : Border.all(
                          color: isEmergency ? AppColors.error : AppColors.glassBorder,
                        ),
                      ),
                      child: Text(
                        msg['text'],
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: isEmergency ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(color: AppColors.cyan),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: AdaptiveCard(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: 'Type your symptoms...',
                          border: InputBorder.none,
                        ),
                        onSubmitted: (v) {
                          HapticFeedback.lightImpact();
                          _sendMessage(v);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  FloatingActionButton(
                    backgroundColor: AppColors.cyan,
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      _sendMessage(_controller.text);
                    },
                    child: const Icon(Icons.send, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
