enum TherapyType { eye, mental, posture, detox }

class WellnessTherapy {
  final String id;
  final String title;
  final String description;
  final TherapyType type;
  final Duration duration;
  final String audioInstructions;

  WellnessTherapy({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.duration,
    required this.audioInstructions,
  });
}

class WellnessTherapyModule {
  static final List<WellnessTherapy> therapies = [
    WellnessTherapy(
      id: 'eye_roll_1',
      title: 'Eye Rolling Relief',
      description:
          'Gently roll your eyes to lubricate and relax ocular muscles.',
      type: TherapyType.eye,
      duration: const Duration(minutes: 2),
      audioInstructions:
          'Start by looking up. Now slowly rotate your gaze to the right...',
    ),
    WellnessTherapy(
      id: 'breath_1',
      title: 'Ocular Relaxation Breathing',
      description:
          'Synchronize deep breathing with eye closure to reduce stress.',
      type: TherapyType.mental,
      duration: const Duration(minutes: 5),
      audioInstructions:
          'Breathe in for four seconds. Close your eyes tightly...',
    ),
  ];
}
