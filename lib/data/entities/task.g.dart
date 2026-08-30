// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 3;

  @override
  Task read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Task(
      id: fields[0] as String,
      task: fields[1] as String,
      status: fields[3] as bool,
      desc: fields[2] as String?,
      taskDueDate: fields[4] as DateTime?,
      groupId: fields[5] as String?,
      isStared: fields[6] as bool,
      groupOrder: fields[7] as int?,
      starredOrder: fields[8] as int?,
      allOrder: fields[9] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.task)
      ..writeByte(2)
      ..write(obj.desc)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.taskDueDate)
      ..writeByte(5)
      ..write(obj.groupId)
      ..writeByte(6)
      ..write(obj.isStared)
      ..writeByte(7)
      ..write(obj.groupOrder)
      ..writeByte(8)
      ..write(obj.starredOrder)
      ..writeByte(9)
      ..write(obj.allOrder);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
