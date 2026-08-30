// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_setting.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ApplicationSettingAdapter extends TypeAdapter<ApplicationSetting> {
  @override
  final int typeId = 7;

  @override
  ApplicationSetting read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ApplicationSetting(
      themeMode: fields[0] as String,
      scheduleView: fields[1] as bool,
      ringtoneUri: fields[2] as String?,
      ringtoneTitle: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ApplicationSetting obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.themeMode)
      ..writeByte(1)
      ..write(obj.scheduleView)
      ..writeByte(2)
      ..write(obj.ringtoneUri)
      ..writeByte(3)
      ..write(obj.ringtoneTitle);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApplicationSettingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
