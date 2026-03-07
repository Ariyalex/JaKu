import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:jaku/main.dart';

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
  final DateTime createdOn;

  @HiveField(5)
  final DateTime editedOn;

  const Note({
    required this.id,
    this.matkulId,
    this.title,
    this.desc,
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
    );
  }

  factory Note.create({String? desc, String? title, String? matkulId}) {
    return Note(
      id: uuid.v4(),
      createdOn: DateTime.now(),
      editedOn: DateTime.now(),
      desc: desc,
      title: title,
      matkulId: matkulId,
    );
  }

  @override
  List<Object?> get props => [id, title, desc, createdOn, editedOn, matkulId];
}
