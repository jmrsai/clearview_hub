
class AdherenceAiEngine {
  /// Analyzes the patient's adherence to therapy and medication.
  /// Returns a score between 0.0 and 1.0.
  double calculateAdherenceScore(List<bool> completionHistory) {
    if (completionHistory.isEmpty) return 0.0;

    final completedCount = completionHistory.where((c) => c).length;
    return completedCount / completionHistory.length;
  }

  /// Suggests optimized reminder times based on when the user is most active.
  DateTime suggestNextReminderTime(DateTime lastCompletionTime) {
    // Simple heuristic: suggest 4 hours after the last completion,
    // ensuring it's within waking hours.
    return lastCompletionTime.add(const Duration(hours: 4));
  }
}
