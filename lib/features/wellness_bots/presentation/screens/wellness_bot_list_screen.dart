import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/services/wellness_bot_service.dart';
import 'wellness_bot_chat_screen.dart';

class WellnessBotListScreen extends ConsumerWidget {
  const WellnessBotListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final botService = ref.watch(wellnessBotServiceProvider);
    final bots = botService.getAvailableBots();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wellness Bots'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: bots.length,
        itemBuilder: (context, index) {
          final bot = bots[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            color: const Color(0xFF16213E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              leading: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.blueAccent.withValues(alpha: 0.2),
                child: bot.avatarPath.isNotEmpty
                    ? Image.asset(
                        bot.avatarPath,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.smart_toy,
                          color: Colors.blueAccent,
                        ),
                      )
                    : const Icon(Icons.smart_toy, color: Colors.blueAccent),
              ),
              title: Text(
                bot.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              subtitle: Text(
                bot.description,
                style: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WellnessBotChatScreen(bot: bot),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
