import 'package:equatable/equatable.dart';
import 'package:jaku/data/entities/note.dart';

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

class SearchNotes extends NoteEvent {
  final String query;
  const SearchNotes(this.query);

  @override
  List<Object?> get props => [query];
}

class FilterNotesByMatkul extends NoteEvent {
  final String matkulId;
  const FilterNotesByMatkul(this.matkulId);

  @override
  List<Object?> get props => [matkulId];
}

class SortNotes extends NoteEvent {
  final int activeIndex;
  final bool isAsce;
  final bool isSorting;
  final bool isSortByCreatedDate;

  const SortNotes({
    required this.activeIndex,
    required this.isAsce,
    required this.isSorting,
    required this.isSortByCreatedDate,
  });

  @override
  List<Object?> get props => [
    activeIndex,
    isAsce,
    isSorting,
    isSortByCreatedDate,
  ];
}
