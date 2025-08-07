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
      id: fields[0] as String?,
      task: fields[1] as String,
      status: fields[3] as bool,
      desc: fields[2] as String?,
      taskDueDate: fields[4] as DateTime?,
      taskDueTime: fields[5] as TimeOfDay?,
      matkul: fields[6] as String?,
      isStared: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(8)
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
      ..write(obj.taskDueTime)
      ..writeByte(6)
      ..write(obj.matkul)
      ..writeByte(7)
      ..write(obj.isStared);
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
