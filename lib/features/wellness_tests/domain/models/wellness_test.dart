enum WellnessTestCategory { eye, addiction, posture, sleep }

class WellnessTest {
  final String id;
  final String title;
  final String description;
  final WellnessTestCategory category;
  final List<String> questions;

  WellnessTest({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.questions = const [],
  });
}

class WellnessTestModule {
  static final List<WellnessTest> tests = [
    WellnessTest(
      id: 'eye_strain_1',
      title: 'Digital Eye Strain Check',
      description:
          'Quickly assess if your current screen habits are causing strain.',
      category: WellnessTestCategory.eye,
      questions: [
        'Do your eyes feel dry or irritated?',
        'Is your vision blurry after long use?',
        'Do you experience frequent headaches?',
      ],
    ),
    WellnessTest(
      id: 'addiction_1',
      title: 'Screen Dependency Scale',
      description: 'Evaluate your level of attachment to your device.',
      category: WellnessTestCategory.addiction,
      questions: [
        'Do you feel anxious without your phone?',
        'Do you often find yourself doom-scrolling?',
        'Has screen time affected your sleep?',
      ],
    ),
  ];
}
