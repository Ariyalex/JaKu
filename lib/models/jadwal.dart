import 'package:hive/hive.dart';
part 'jadwal.g.dart';

class HariKuliah {
  String? scheduleId;

  String day;

  HariKuliah({this.scheduleId, required this.day});
}

@HiveType(typeId: 0)
class Jadwal extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? matkulId;

  @HiveField(2)
  String day;

  @HiveField(3)
  String matkul;

  @HiveField(4)
  String? dosen1;

  @HiveField(5)
  String? dosen2;

  @HiveField(6)
  String? kelas;

  @HiveField(7)
  String? room;

  @HiveField(8)
  String formattedJamAwal;

  @HiveField(9)
  String? formattedJamAkhir;

  Jadwal({
    required this.day,
    this.id,
    this.matkulId,
    required this.matkul,
    this.dosen1,
    this.dosen2,
    this.kelas,
    required this.formattedJamAwal,
    this.formattedJamAkhir,
    this.room,
  });
}
