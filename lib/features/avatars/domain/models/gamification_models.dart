import 'package:freezed_annotation/freezed_annotation.dart';

part 'gamification_models.freezed.dart';
part 'gamification_models.g.dart';

@freezed
class Achievement with _$Achievement {
  const factory Achievement({
    required String id,
    required String title,
    required String description,
    required String iconUrl,
    @Default(false) bool isUnlocked,
    DateTime? unlockedAt,
    @Default(0) int xpReward,
  }) = _Achievement;

  factory Achievement.fromJson(Map<String, dynamic> json) =>
      _$AchievementFromJson(json);
}

@freezed
class UserStats with _$UserStats {
  const factory UserStats({
    required String userId,
    @Default(1) int level,
    @Default(0) int currentXp,
    @Default(1000) int nextLevelXp,
    @Default(0) int totalBlinks,
    @Default(0) int totalExercisesDone,
    @Default(0) int dailyStreak,
    @Default([]) List<String> unlockedAchievementIds,
  }) = _UserStats;

  factory UserStats.fromJson(Map<String, dynamic> json) =>
      _$UserStatsFromJson(json);
}
