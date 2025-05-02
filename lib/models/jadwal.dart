class HariKuliah {
  String? matkulId;
  String? day;

  HariKuliah({this.matkulId, this.day});
}

class Matkul extends HariKuliah {
  String? matkul,
      dosen1,
      dosen2,
      kelas,
      room,
      formattedJamAwal,
      formattedJamAkhir;

  Matkul({
    required super.day,
    super.matkulId,
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
