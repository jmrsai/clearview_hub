// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eye_twin_metrics.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EyeTwinMetricsAdapter extends TypeAdapter<EyeTwinMetrics> {
  @override
  final int typeId = 1;

  @override
  EyeTwinMetrics read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EyeTwinMetrics(
      patientId: fields[0] as String,
      visualAcuityScore: fields[1] as double,
      screenTimeHours: fields[2] as double,
      fatigueLevel: fields[3] as double,
      therapyAdherence: fields[4] as double,
      lastUpdated: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, EyeTwinMetrics obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.patientId)
      ..writeByte(1)
      ..write(obj.visualAcuityScore)
      ..writeByte(2)
      ..write(obj.screenTimeHours)
      ..writeByte(3)
      ..write(obj.fatigueLevel)
      ..writeByte(4)
      ..write(obj.therapyAdherence)
      ..writeByte(5)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EyeTwinMetricsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
