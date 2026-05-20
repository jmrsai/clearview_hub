// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diagnostic_report.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DiagnosticReportAdapter extends TypeAdapter<DiagnosticReport> {
  @override
  final int typeId = 2;

  @override
  DiagnosticReport read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DiagnosticReport(
      id: fields[0] as String,
      patientId: fields[1] as String,
      type: fields[2] as String,
      confidence: fields[3] as double,
      hasCriticalFinding: fields[4] as bool,
      result: fields[5] as String,
      timestamp: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, DiagnosticReport obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.patientId)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.confidence)
      ..writeByte(4)
      ..write(obj.hasCriticalFinding)
      ..writeByte(5)
      ..write(obj.result)
      ..writeByte(6)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiagnosticReportAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
