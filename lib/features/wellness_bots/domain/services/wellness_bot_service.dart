import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class WellnessBot {
  final String id;
  final String name;
  final String description;
  final String avatarPath;
  final BotType type;

  WellnessBot({
    required this.id,
    required this.name,
    required this.description,
    required this.avatarPath,
    required this.type,
  });
}

enum BotType {
  eyeHealth,
  focusReminder,
  therapyAssistant,
  sleepReminder,
  detoxChallenge,
  aiCompanion, // Futuristic emotion-aware companion
}

/// Telegram-style Bot Service for Wellness
class WellnessBotService {
  final List<WellnessBot> _availableBots = [
    WellnessBot(
      id: const Uuid().v4(),
      name: 'Eve - AI Companion',
      description:
          'Futuristic emotion-aware companion predicting fatigue and managing focus.',
      avatarPath: 'assets/ai_assistant/eve_avatar.png',
      type: BotType.aiCompanion,
    ),
    WellnessBot(
      id: const Uuid().v4(),
      name: 'Eye Health Bot',
      description: 'Automated reminders for the 20-20-20 rule and blinking.',
      avatarPath: 'assets/ai_assistant/eye_bot.png',
      type: BotType.eyeHealth,
    ),
    WellnessBot(
      id: const Uuid().v4(),
      name: 'Focus Reminder Bot',
      description: 'AI suggestions to keep you in flow state.',
      avatarPath: 'assets/ai_assistant/focus_bot.png',
      type: BotType.focusReminder,
    ),
    WellnessBot(
      id: const Uuid().v4(),
      name: 'Therapy Assistant Bot',
      description: 'Daily check-ins and progress tracking for therapy.',
      avatarPath: 'assets/ai_assistant/therapy_bot.png',
      type: BotType.therapyAssistant,
    ),
    WellnessBot(
      id: const Uuid().v4(),
      name: 'Sleep Reminder Bot',
      description: 'Wind down reminders and screen dimming tips.',
      avatarPath: 'assets/ai_assistant/sleep_bot.png',
      type: BotType.sleepReminder,
    ),
  ];

  List<WellnessBot> getAvailableBots() => _availableBots;

  String getAutomatedReminder(BotType type, {String? detectedMood}) {
    switch (type) {
      case BotType.aiCompanion:
        if (detectedMood == 'stressed') {
          return 'I sense your stress levels are elevated. Should I queue a 5-minute guided meditation?';
        }
        return "I predict a 70% chance of eye fatigue in the next hour based on your current screen usage. Let's take a proactive break.";
      case BotType.eyeHealth:
        return 'Time for a 20-20-20 break! Look at something 20 feet away for 20 seconds.';
      case BotType.focusReminder:
        return "You've been distracted 3 times in the last hour. Let's refocus.";
      case BotType.therapyAssistant:
        return "How are you feeling today? Let's do a quick mood check-in.";
      case BotType.sleepReminder:
        return "It's getting late. Consider turning on the blue light filter.";
      case BotType.detoxChallenge:
        return 'You are 3 hours into your detox. Keep going!';
    }
  }
}

final wellnessBotServiceProvider = Provider((ref) => WellnessBotService());
