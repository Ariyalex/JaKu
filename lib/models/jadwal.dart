import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class HariKuliah extends HiveObject {
  @HiveField(0)
  String? matkulId;

  @HiveField(1)
  String day;

  HariKuliah({this.matkulId, required this.day});
}

@HiveType(typeId: 0)
class Matkul extends HiveObject {
  @HiveField(0)
  String? matkulId;

  @HiveField(1)
  String day;

  @HiveField(2)
  String matkul;

  @HiveField(3)
  String? dosen1;

  @HiveField(4)
  String? dosen2;

  @HiveField(5)
  String? kelas;

  @HiveField(6)
  String? room;

  @HiveField(7)
  String formattedJamAwal;

  @HiveField(8)
  String? formattedJamAkhir;

  Matkul({
    required this.day,
    this.matkulId,
    required this.matkul,
    this.dosen1,
    this.dosen2,
    this.kelas,
    required this.formattedJamAwal,
    this.formattedJamAkhir,
    this.room,
  });

  Map<String, dynamic> toJson() {
    return {
      "day": day,
      "matkul": matkul,
      "dosen1": dosen1,
      "dosen2": dosen2,
      "kelas": kelas,
      "formattedJamAwal": formattedJamAwal,
      "formattedJamAkhir": formattedJamAkhir,
      "room": room,
    };
  }

  factory Matkul.fromJson(String matkulId, Map<String, dynamic> json) {
    return Matkul(
      matkulId: matkulId,
      day: json["day"],
      matkul: json["matkul"],
      dosen1: json["dosen1"],
      dosen2: json["dosen2"],
      kelas: json["kelas"],
      formattedJamAwal: json["formattedJamAwal"],
      formattedJamAkhir: json["formattedJamAkhir"],
      room: json["room"],
    );
  }
}

//adapter matkul
class MatkulAdapter extends TypeAdapter<Matkul> {
  @override
  final int typeId = 0;

  @override
  Matkul read(BinaryReader reader) {
    return Matkul(
      matkulId: reader.read(),
      day: reader.read(),
      matkul: reader.read(),
      dosen1: reader.read(),
      dosen2: reader.read(),
      kelas: reader.read(),
      formattedJamAwal: reader.read(),
      formattedJamAkhir: reader.read(),
      room: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, Matkul obj) {
    writer.write(obj.matkulId);
    writer.write(obj.day);
    writer.write(obj.matkul);
    writer.write(obj.dosen1);
    writer.write(obj.dosen2);
    writer.write(obj.kelas);
    writer.write(obj.formattedJamAwal);
    writer.write(obj.formattedJamAkhir);
    writer.write(obj.room);
  }
}
