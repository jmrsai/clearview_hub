// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vision_test_result.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VisionTestResultAdapter extends TypeAdapter<VisionTestResult> {
  @override
  final int typeId = 2;

  @override
  VisionTestResult read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VisionTestResult(
      id: fields[0] as String,
      patientId: fields[1] as String,
      date: fields[2] as DateTime,
      testType: fields[3] as String,
      results: (fields[4] as Map).cast<String, dynamic>(),
      eyeFatigueScore: fields[5] as double,
      isSynced: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, VisionTestResult obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.patientId)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.testType)
      ..writeByte(4)
      ..write(obj.results)
      ..writeByte(5)
      ..write(obj.eyeFatigueScore)
      ..writeByte(6)
      ..write(obj.isSynced);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VisionTestResultAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
