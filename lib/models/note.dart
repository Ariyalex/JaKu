import 'package:hive/hive.dart';

part 'note.g.dart';

@HiveType(typeId: 2)
class Note extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? title;

  @HiveField(2)
  String? desc;

  @HiveField(3)
  String? matkul;

  Note({
    this.id,
    this.title,
    this.desc,
    this.matkul,
  });
}
