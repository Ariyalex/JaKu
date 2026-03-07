import 'package:equatable/equatable.dart';
import 'package:jaku/data/entities/note.dart';

enum NoteStatus { initial, loading, success, error }

class NoteState extends Equatable {
  final List<Note> allNotes;
  final List<Note> filteredNotes;
  final Note? selectedNote;
  final NoteStatus status;
  final String? message;
  
  // UI States
  final String searchQuery;
  final String filterMatkulId;
  final int sortActiveIndex;
  final bool isAsce;
  final bool isSorting;
  final bool isSortByCreatedDate;

  const NoteState({
    this.allNotes = const [],
    this.filteredNotes = const [],
    this.selectedNote,
    this.status = NoteStatus.initial,
    this.message,
    this.searchQuery = '',
    this.filterMatkulId = 'all',
    this.sortActiveIndex = 0,
    this.isAsce = true,
    this.isSorting = false,
    this.isSortByCreatedDate = true,
  });

  NoteState copyWith({
    List<Note>? allNotes,
    List<Note>? filteredNotes,
    Note? selectedNote,
    NoteStatus? status,
    String? message,
    String? searchQuery,
    String? filterMatkulId,
    int? sortActiveIndex,
    bool? isAsce,
    bool? isSorting,
    bool? isSortByCreatedDate,
    bool clearSelected = false,
  }) {
    return NoteState(
      allNotes: allNotes ?? this.allNotes,
      filteredNotes: filteredNotes ?? this.filteredNotes,
      selectedNote: clearSelected ? null : (selectedNote ?? this.selectedNote),
      status: status ?? this.status,
      message: message ?? this.message,
      searchQuery: searchQuery ?? this.searchQuery,
      filterMatkulId: filterMatkulId ?? this.filterMatkulId,
      sortActiveIndex: sortActiveIndex ?? this.sortActiveIndex,
      isAsce: isAsce ?? this.isAsce,
      isSorting: isSorting ?? this.isSorting,
      isSortByCreatedDate: isSortByCreatedDate ?? this.isSortByCreatedDate,
    );
  }

  @override
  List<Object?> get props => [
        allNotes,
        filteredNotes,
        selectedNote,
        status,
        message,
        searchQuery,
        filterMatkulId,
        sortActiveIndex,
        isAsce,
        isSorting,
        isSortByCreatedDate,
      ];
}
