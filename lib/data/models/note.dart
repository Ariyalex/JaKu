import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'note.g.dart';

@HiveType(typeId: 2)
class Note extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String? matkulId;

  @HiveField(2)
  final String? title;

  @HiveField(3)
  final String? desc;

  @HiveField(4)
  final String? matkul;

  @HiveField(5)
  final DateTime createdOn;

  @HiveField(6)
  final DateTime editedOn;

  const Note({
    required this.id,
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
      id: this.id,
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

  @override
  // TODO: implement props
  List<Object?> get props => [
    id,
    title,
    desc,
    createdOn,
    editedOn,
    matkul,
    matkulId,
  ];
}
