// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_reminder.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScheduleReminderAdapter extends TypeAdapter<ScheduleReminder> {
  @override
  final int typeId = 8;

  @override
  ScheduleReminder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ScheduleReminder(
      id: fields[0] as String,
      offsetMinutes: fields[1] as int,
      isNotificationOnly: fields[2] as bool,
      isEnabled: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ScheduleReminder obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.offsetMinutes)
      ..writeByte(2)
      ..write(obj.isNotificationOnly)
      ..writeByte(3)
      ..write(obj.isEnabled);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScheduleReminderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
