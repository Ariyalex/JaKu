import 'package:equatable/equatable.dart';
import 'package:jaku/data/models/note.dart';

abstract class NoteEvent extends Equatable {
  const NoteEvent();

  @override
  List<Object?> get props => [];
}

class LoadListNote extends NoteEvent {}

class LoadListNoteByMatkul extends NoteEvent {
  final String matkulId;
  const LoadListNoteByMatkul(this.matkulId);

  @override
  List<Object?> get props => [matkulId];
}

class LoadNote extends NoteEvent {
  final String id;
  const LoadNote(this.id);

  @override
  List<Object?> get props => [id];
}

class AddNote extends NoteEvent {
  final Note note;

  const AddNote(this.note);

  @override
  List<Object?> get props => [note];
}

class UpdateNote extends NoteEvent {
  final Note note;
  const UpdateNote(this.note);

  @override
  List<Object?> get props => [note];
}

class DeleteNote extends NoteEvent {
  final String id;
  const DeleteNote(this.id);

  @override
  List<Object?> get props => [id];
}

class DeleteAllNote extends NoteEvent {}
