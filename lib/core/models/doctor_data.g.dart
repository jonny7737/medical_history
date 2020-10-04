// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DoctorDataAdapter extends TypeAdapter<DoctorData> {
  @override
  final int typeId = 1;

  @override
  DoctorData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DoctorData(
      id: fields[0] as int,
      owner: fields[1] as String,
      name: fields[2] as String,
      phone: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DoctorData obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.owner)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.phone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DoctorDataAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
