// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'matkul_schedule.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MatkulScheduleAdapter extends TypeAdapter<MatkulSchedule> {
  @override
  final int typeId = 0;

  @override
  MatkulSchedule read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MatkulSchedule(
      id: fields[0] as String,
      matkulId: fields[1] as String,
      day: fields[2] as Day,
      startTime: fields[3] as TimeOfDay,
      endTime: fields[4] as TimeOfDay?,
      room: fields[5] as String?,
      alarms: fields[6] == null
          ? []
          : (fields[6] as List).cast<ScheduleReminder>(),
    );
  }

  @override
  void write(BinaryWriter writer, MatkulSchedule obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.matkulId)
      ..writeByte(2)
      ..write(obj.day)
      ..writeByte(3)
      ..write(obj.startTime)
      ..writeByte(4)
      ..write(obj.endTime)
      ..writeByte(5)
      ..write(obj.room)
      ..writeByte(6)
      ..write(obj.alarms);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MatkulScheduleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
