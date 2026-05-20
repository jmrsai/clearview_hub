// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gamification_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AchievementImpl _$$AchievementImplFromJson(Map<String, dynamic> json) =>
    _$AchievementImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      iconUrl: json['iconUrl'] as String,
      isUnlocked: json['isUnlocked'] as bool? ?? false,
      unlockedAt: json['unlockedAt'] == null
          ? null
          : DateTime.parse(json['unlockedAt'] as String),
      xpReward: (json['xpReward'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$AchievementImplToJson(_$AchievementImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'iconUrl': instance.iconUrl,
      'isUnlocked': instance.isUnlocked,
      'unlockedAt': instance.unlockedAt?.toIso8601String(),
      'xpReward': instance.xpReward,
    };

_$UserStatsImpl _$$UserStatsImplFromJson(Map<String, dynamic> json) =>
    _$UserStatsImpl(
      userId: json['userId'] as String,
      level: (json['level'] as num?)?.toInt() ?? 1,
      currentXp: (json['currentXp'] as num?)?.toInt() ?? 0,
      nextLevelXp: (json['nextLevelXp'] as num?)?.toInt() ?? 1000,
      totalBlinks: (json['totalBlinks'] as num?)?.toInt() ?? 0,
      totalExercisesDone: (json['totalExercisesDone'] as num?)?.toInt() ?? 0,
      dailyStreak: (json['dailyStreak'] as num?)?.toInt() ?? 0,
      unlockedAchievementIds: (json['unlockedAchievementIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$UserStatsImplToJson(_$UserStatsImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'level': instance.level,
      'currentXp': instance.currentXp,
      'nextLevelXp': instance.nextLevelXp,
      'totalBlinks': instance.totalBlinks,
      'totalExercisesDone': instance.totalExercisesDone,
      'dailyStreak': instance.dailyStreak,
      'unlockedAchievementIds': instance.unlockedAchievementIds,
    };
