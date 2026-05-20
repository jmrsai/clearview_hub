
class EyeExercise {
  final String title;
  final String description;
  final String animationPath;
  final Duration duration;
  final String voiceInstructions;

  const EyeExercise({
    required this.title,
    required this.description,
    required this.animationPath,
    required this.duration,
    required this.voiceInstructions,
  });
}

class EyeExerciseModule {
  static const List<EyeExercise> exercises = [
    EyeExercise(
      title: '20-20-20 Rule',
      description:
          'Every 20 minutes, look at something 20 feet away for 20 seconds.',
      animationPath: 'assets/lottie/focus_shift.json',
      duration: Duration(seconds: 20),
      voiceInstructions:
          'Look at an object at least 20 feet away. Keep your eyes relaxed for 20 seconds.',
    ),
    EyeExercise(
      title: 'Rapid Blinking',
      description: 'Blink quickly for 10 seconds to lubricate your eyes.',
      animationPath: 'assets/lottie/blink_exercise.json',
      duration: Duration(seconds: 10),
      voiceInstructions:
          'Start blinking rapidly now. This helps moisten your eyes.',
    ),
    EyeExercise(
      title: 'Eye Rolling (Yoga)',
      description:
          'Gently roll your eyes in a circle to strengthen eye muscles.',
      animationPath: 'assets/lottie/eye_yoga.json',
      duration: Duration(seconds: 30),
      voiceInstructions:
          'Gently roll your eyes in a slow circle. First clockwise, then counter-clockwise.',
    ),
    EyeExercise(
      title: 'Near & Far Focus',
      description: 'Shift focus between your thumb and a distant object.',
      animationPath: 'assets/lottie/focus_depth.json',
      duration: Duration(seconds: 40),
      voiceInstructions:
          'Hold your thumb near your face. Focus on it, then look at the wall behind it. Repeat.',
    ),
  ];
}
