import 'package:equatable/equatable.dart';
import 'package:jaku/data/entities/note.dart';

abstract class NoteState extends Equatable {
  const NoteState();

  @override
  List<Object?> get props => [];
}

class NoteInitial extends NoteState {}

class NoteListLoading extends NoteState {}

class NoteLoading extends NoteState {}

class NoteListByMatkulLoading extends NoteState {}

class NoteListLoaded extends NoteState {
  final List<Note> notes;
  const NoteListLoaded(this.notes);

  @override
  List<Object?> get props => [notes];
}

class NoteListByMatkulLoaded extends NoteState {
  final List<Note> notes;
  const NoteListByMatkulLoaded(this.notes);

  @override
  List<Object?> get props => [notes];
}

class NoteLoaded extends NoteState {
  final Note note;
  const NoteLoaded(this.note);

  @override
  List<Object?> get props => [note];
}

class NoteError extends NoteState {
  final String message;
  const NoteError(this.message);

  @override
  List<Object?> get props => [message];
}
