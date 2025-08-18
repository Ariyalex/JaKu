// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'matkul.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MatkulAdapter extends TypeAdapter<Matkul> {
  @override
  final int typeId = 1;

  @override
  Matkul read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Matkul(
      id: fields[0] as String?,
      matkul: fields[1] as String,
      abbreviation: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Matkul obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.matkul)
      ..writeByte(2)
      ..write(obj.abbreviation);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MatkulAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
