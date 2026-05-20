class ReminderEngine {
  /// Logic for triggering health reminders based on device state.
  List<String> getPendingReminders({
    required Duration screenTimeSession,
    required double ambientLightLux,
    required double blinkRatePerMinute,
  }) {
    final List<String> reminders = [];

    if (screenTimeSession.inMinutes >= 20) {
      reminders.add('20 minutes reached. Look at something 20 feet away!');
    }

    if (ambientLightLux < 20) {
      reminders.add(
        'Environment too dark. Increase room light to reduce strain.',
      );
    }

    if (blinkRatePerMinute < 10) {
      reminders.add('Low blink rate detected. Try to blink more often.');
    }

    return reminders;
  }
}
