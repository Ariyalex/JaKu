import 'package:hive/hive.dart';

part 'note.g.dart';

@HiveType(typeId: 2)
class Note extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? matkulId;

  @HiveField(2)
  String? title;

  @HiveField(3)
  String? desc;

  @HiveField(4)
  String? matkul;

  @HiveField(5)
  DateTime? createdOn;

  @HiveField(6)
  DateTime? editedOn;

  Note({
    this.id,
    this.matkulId,
    this.title,
    this.desc,
    this.matkul,
    this.createdOn,
    this.editedOn,
  });
}
