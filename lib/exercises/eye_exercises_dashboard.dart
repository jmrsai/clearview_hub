import 'package:flutter/material.dart';
import '../../widgets/glass_card.dart';
import '../exercises/eye_exercise_model.dart';

class EyeExercisesDashboard extends StatelessWidget {
  const EyeExercisesDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Guided Eye Exercises')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: EyeExerciseModule.exercises.length,
        itemBuilder: (context, index) {
          final exercise = EyeExerciseModule.exercises[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: GlassCard(
              padding: const EdgeInsets.all(16),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.white12,
                  child: Icon(Icons.play_arrow, color: Colors.greenAccent),
                ),
                title: Text(
                  exercise.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  exercise.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(
                  '${exercise.duration.inSeconds}s',
                  style: const TextStyle(color: Colors.white38),
                ),
                onTap: () {
                  // TODO: Open exercise player
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
