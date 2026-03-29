import 'package:equatable/equatable.dart';
import 'package:jaku/data/entities/note.dart';

enum NoteStatus { initial, loading, success, actionSuccess, error }

class NoteState extends Equatable {
  final List<Note> allNotes;
  final List<Note> filteredNotes;
  final List<Note> filteredNoteByMatkul;
  final Note? selectedNote;
  final String? lastLoadedId;
  final NoteStatus status;
  final String? message;

  // UI States
  final String searchQuery;
  final String filterMatkulId;
  final int sortActiveIndex;
  final bool isAsce;
  final bool isSortByCreatedDate;

  const NoteState({
    this.allNotes = const [],
    this.filteredNotes = const [],
    this.filteredNoteByMatkul = const [],
    this.selectedNote,
    this.lastLoadedId,
    this.status = NoteStatus.initial,
    this.message,
    this.searchQuery = '',
    this.filterMatkulId = 'all',
    this.sortActiveIndex = 0,
    this.isAsce = false,
    this.isSortByCreatedDate = true,
  });

  NoteState copyWith({
    List<Note>? allNotes,
    List<Note>? filteredNotes,
    List<Note>? filteredNoteByMatkul,
    Note? selectedNote,
    String? lastLoadedId,
    NoteStatus? status,
    String? message,
    String? searchQuery,
    String? filterMatkulId,
    int? sortActiveIndex,
    bool? isAsce,
    bool? isSortByCreatedDate,
    bool clearSelected = false,
  }) {
    return NoteState(
      allNotes: allNotes ?? this.allNotes,
      filteredNotes: filteredNotes ?? this.filteredNotes,
      filteredNoteByMatkul: filteredNoteByMatkul ?? this.filteredNoteByMatkul,
      selectedNote: clearSelected ? null : (selectedNote ?? this.selectedNote),
      lastLoadedId: lastLoadedId ?? this.lastLoadedId,
      status: status ?? this.status,
      message: message ?? this.message,
      searchQuery: searchQuery ?? this.searchQuery,
      filterMatkulId: filterMatkulId ?? this.filterMatkulId,
      sortActiveIndex: sortActiveIndex ?? this.sortActiveIndex,
      isAsce: isAsce ?? this.isAsce,
      isSortByCreatedDate: isSortByCreatedDate ?? this.isSortByCreatedDate,
    );
  }

  @override
  List<Object?> get props => [
    allNotes,
    filteredNotes,
    filteredNoteByMatkul,
    selectedNote,
    lastLoadedId,
    status,
    message,
    searchQuery,
    filterMatkulId,
    sortActiveIndex,
    isAsce,
    isSortByCreatedDate,
  ];
}
