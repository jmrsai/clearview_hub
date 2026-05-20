enum GameCategory { eye, attention, habit }

class WellnessGame {
  final String id;
  final String title;
  final String description;
  final GameCategory category;
  final int rewardXP;

  WellnessGame({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.rewardXP = 50,
  });
}

class WellnessGamesModule {
  static final List<WellnessGame> games = [
    WellnessGame(
      id: 'blink_speed_1',
      title: 'Blink Blitz',
      description:
          'How fast can you blink? Improve eye lubrication through play.',
      category: GameCategory.eye,
      rewardXP: 100,
    ),
    WellnessGame(
      id: 'memory_1',
      title: 'Eye Memory',
      description: 'Track moving objects and remember their positions.',
      category: GameCategory.attention,
      rewardXP: 80,
    ),
  ];
}
