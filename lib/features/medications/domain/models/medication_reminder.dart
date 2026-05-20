import 'package:freezed_annotation/freezed_annotation.dart';

part 'medication_reminder.freezed.dart';
part 'medication_reminder.g.dart';

@freezed
class MedicationReminder with _$MedicationReminder {
  const factory MedicationReminder({
    required String id,
    required String medicationName,
    required String dosage,
    required DateTime time,
    @Default(true) bool isActive,
    @Default([]) List<DateTime> history,
  }) = _MedicationReminder;

  factory MedicationReminder.fromJson(Map<String, dynamic> json) =>
      _$MedicationReminderFromJson(json);
}
