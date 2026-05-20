enum AgeGroup {
  child, // 5-12
  teen, // 13-19
  adult, // 20-50
  senior, // 50+
}

class AgeProfile {
  final AgeGroup group;
  final String displayName;
  final String iconPath;
  final bool strictLimits;
  final double baseExerciseDifficulty; // 0.0 - 1.0

  const AgeProfile({
    required this.group,
    required this.displayName,
    required this.iconPath,
    this.strictLimits = false,
    this.baseExerciseDifficulty = 0.5,
  });

  static AgeProfile forGroup(AgeGroup group) {
    switch (group) {
      case AgeGroup.child:
        return const AgeProfile(
          group: AgeGroup.child,
          displayName: 'Little Hero',
          iconPath: 'assets/icons/child_hero.png',
          strictLimits: true,
          baseExerciseDifficulty: 0.3,
        );
      case AgeGroup.teen:
        return const AgeProfile(
          group: AgeGroup.teen,
          displayName: 'Focus Pro',
          iconPath: 'assets/icons/teen_focus.png',
          strictLimits: false,
          baseExerciseDifficulty: 0.7,
        );
      case AgeGroup.adult:
        return const AgeProfile(
          group: AgeGroup.adult,
          displayName: 'Wellness Expert',
          iconPath: 'assets/icons/adult_expert.png',
          strictLimits: false,
          baseExerciseDifficulty: 0.6,
        );
      case AgeGroup.senior:
        return const AgeProfile(
          group: AgeGroup.senior,
          displayName: 'Wisdom Seeker',
          iconPath: 'assets/icons/senior_wisdom.png',
          strictLimits: false,
          baseExerciseDifficulty: 0.4,
        );
    }
  }
}
