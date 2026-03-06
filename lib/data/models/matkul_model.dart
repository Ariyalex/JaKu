import 'package:jaku/data/entities/matkul.dart';

class MatkulModel extends Matkul {
  const MatkulModel({
    required super.id,
    required super.name,
    required super.nameAbbreviation,
    super.lecturer1,
    super.lecturer2,
  });

  factory MatkulModel.fromJson(Map<String, dynamic> json) {
    return MatkulModel(
      id: json["id"],
      name: json["name"],
      nameAbbreviation: Matkul.matkulAbbreviation(json["name"]),
      lecturer1: json["lecturers"][0]["name"],
      lecturer2: json["lecturers"][1]["name"],
    );
  }

  Matkul toEntity() {
    return Matkul(
      id: id,
      name: name,
      nameAbbreviation: nameAbbreviation,
      lecturer1: lecturer1,
      lecturer2: lecturer2,
    );
  }
}
