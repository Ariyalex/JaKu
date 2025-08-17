// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jadwal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class JadwalAdapter extends TypeAdapter<Jadwal> {
  @override
  final int typeId = 0;

  @override
  Jadwal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Jadwal(
      day: fields[2] as String,
      id: fields[0] as String?,
      matkulId: fields[1] as String?,
      matkul: fields[3] as String,
      dosen1: fields[4] as String?,
      dosen2: fields[5] as String?,
      kelas: fields[6] as String?,
      formattedJamAwal: fields[8] as String,
      formattedJamAkhir: fields[9] as String?,
      room: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Jadwal obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.matkulId)
      ..writeByte(2)
      ..write(obj.day)
      ..writeByte(3)
      ..write(obj.matkul)
      ..writeByte(4)
      ..write(obj.dosen1)
      ..writeByte(5)
      ..write(obj.dosen2)
      ..writeByte(6)
      ..write(obj.kelas)
      ..writeByte(7)
      ..write(obj.room)
      ..writeByte(8)
      ..write(obj.formattedJamAwal)
      ..writeByte(9)
      ..write(obj.formattedJamAkhir);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JadwalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
