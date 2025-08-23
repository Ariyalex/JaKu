// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_tab.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskTabAdapter extends TypeAdapter<TaskTab> {
  @override
  final int typeId = 4;

  @override
  TaskTab read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskTab(
      id: fields[0] as String,
      tabName: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TaskTab obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.tabName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskTabAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
