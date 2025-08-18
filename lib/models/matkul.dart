import 'package:hive/hive.dart';

part 'matkul.g.dart';

@HiveType(typeId: 1)
class Matkul extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String matkul;

  @HiveField(2)
  String abbreviation;
  Matkul({this.id, required this.matkul, required this.abbreviation});
}
