import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class WellnessChannel {
  final String id;
  final String name;
  final String description;
  final bool isPrivate;
  final int subscriberCount;

  WellnessChannel({
    required this.id,
    required this.name,
    required this.description,
    required this.isPrivate,
    required this.subscriberCount,
  });
}

class ChannelPost {
  final String id;
  final String channelId;
  final String content;
  final DateTime timestamp;
  final int likes;
  final List<String> pollOptions; // If poll

  ChannelPost({
    required this.id,
    required this.channelId,
    required this.content,
    required this.timestamp,
    this.likes = 0,
    this.pollOptions = const [],
  });
}

/// Telegram-Style Channels Service
class ChannelService {
  final List<WellnessChannel> _mockChannels = [
    WellnessChannel(
      id: const Uuid().v4(),
      name: 'Eye Health Tips',
      description: 'Daily broadcast of eye health tips by verified doctors.',
      isPrivate: false,
      subscriberCount: 15420,
    ),
    WellnessChannel(
      id: const Uuid().v4(),
      name: 'Focus Motivation',
      description:
          'Stay motivated and focused with daily quotes and Pomodoro sessions.',
      isPrivate: false,
      subscriberCount: 8900,
    ),
    WellnessChannel(
      id: const Uuid().v4(),
      name: 'Digital Detox Clinic',
      description: 'Private channel for members going through a 30-day detox.',
      isPrivate: true,
      subscriberCount: 450,
    ),
  ];

  List<WellnessChannel> getDiscoverableChannels() {
    return _mockChannels.where((c) => !c.isPrivate).toList();
  }

  void broadcastPost(
    String channelId,
    String content, {
    List<String>? pollOptions,
  }) {
    // Logic to send push notifications to all subscribers
    // In production, this would go through Supabase or Firebase Cloud Messaging
  }
}

final channelServiceProvider = Provider((ref) => ChannelService());
