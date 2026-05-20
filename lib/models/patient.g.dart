// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PatientAdapter extends TypeAdapter<Patient> {
  @override
  final int typeId = 0;

  @override
  Patient read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Patient(
      id: fields[0] as String,
      name: fields[1] as String,
      dateOfBirth: fields[2] as DateTime,
      gender: fields[3] as String,
      medicalHistory: (fields[4] as List).cast<String>(),
      hasGlaucomaHistory: fields[5] as bool,
      hasDiabetesHistory: fields[6] as bool,
      lastScreeningDate: fields[7] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Patient obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.dateOfBirth)
      ..writeByte(3)
      ..write(obj.gender)
      ..writeByte(4)
      ..write(obj.medicalHistory)
      ..writeByte(5)
      ..write(obj.hasGlaucomaHistory)
      ..writeByte(6)
      ..write(obj.hasDiabetesHistory)
      ..writeByte(7)
      ..write(obj.lastScreeningDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PatientAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
