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
  DateTime createdOn;

  @HiveField(6)
  DateTime editedOn;

  Note({
    this.id,
    this.matkulId,
    this.title,
    this.desc,
    this.matkul,
    required this.createdOn,
    required this.editedOn,
  });

  Note copyWith({
    String? id,
    String? title,
    String? desc,
    DateTime? createdOn,
    DateTime? editedOn,
    String? matkulId,
    String? matkul,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      desc: desc ?? this.desc,
      createdOn: createdOn ?? this.createdOn,
      editedOn: editedOn ?? this.editedOn,
      matkulId: identical(matkulId, null)
          ? null
          : (matkulId as String?) ?? this.matkulId,
      matkul: identical(matkul, null)
          ? null
          : (matkul as String?) ?? this.matkul,
    );
  }
}
