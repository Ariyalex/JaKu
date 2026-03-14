import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jaku/data/entities/note.dart';
import 'package:jaku/data/repositories/note_repositoruy.dart';
import 'package:jaku/modules/note/bloc/note_event.dart';
import 'package:jaku/modules/note/bloc/note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final NoteRepository _repository;

  NoteBloc(this._repository) : super(const NoteState()) {
    on<LoadListNote>(_onLoadListNote);
    on<LoadListNoteByMatkul>(_onLoadListNoteByMatkul);
    on<LoadNote>(_onLoadNote);
    on<AddNote>(_onAddNote);
    on<UpdateNote>(_onUpdateNote);
    on<DeleteNote>(_onDeleteNote);
    on<DeleteAllNote>(_onDeleteAllNote);

    // New events for UI state
    on<SearchNotes>(_onSearchNotes);
    on<FilterNotesByMatkul>(_onFilterNotesByMatkul);
    on<SortNotes>(_onSortNotes);
  }

  NoteState _applyFilters(NoteState currentState) {
    List<Note> result = List.from(currentState.allNotes);

    // 1. Search
    if (currentState.searchQuery.isNotEmpty) {
      final query = currentState.searchQuery.toLowerCase();
      result = result.where((note) {
        final title = note.title?.toLowerCase() ?? '';
        final desc = note.desc?.toLowerCase() ?? '';
        return title.contains(query) || desc.contains(query);
      }).toList();
    }

    // 2. Filter by Matkul
    if (currentState.filterMatkulId != 'all' &&
        currentState.filterMatkulId.isNotEmpty) {
      final parts = currentState.filterMatkulId
          .split(',')
          .map((e) => e.trim())
          .where((element) => element.isNotEmpty)
          .toList();
      final includeUmum = parts.contains('umum');
      final specificIds = parts.where((element) => element != 'umum').toSet();

      result = result.where((note) {
        if (includeUmum && (note.matkulId == null || note.matkulId!.isEmpty)) {
          return true;
        }
        if (specificIds.isNotEmpty &&
            note.matkulId != null &&
            specificIds.contains(note.matkulId)) {
          return true;
        }
        return false;
      }).toList();
    }

    // 3. Sort
    if (currentState.isSortByCreatedDate) {
      if (currentState.isAsce) {
        result.sort((a, b) => a.createdOn.compareTo(b.createdOn));
      } else {
        result.sort((a, b) => b.createdOn.compareTo(a.createdOn));
      }
    } else {
      if (currentState.isAsce) {
        result.sort((a, b) => a.editedOn.compareTo(b.editedOn));
      } else {
        result.sort((a, b) => b.editedOn.compareTo(a.editedOn));
      }
    }

    return currentState.copyWith(filteredNotes: result);
  }

  Future<void> _onLoadListNote(
    LoadListNote event,
    Emitter<NoteState> emit,
  ) async {
    emit(state.copyWith(status: NoteStatus.loading, lastLoadedId: null));
    try {
      final notes = _repository.getAllNote();

      // Filter out empty notes
      final validNotes = <Note>[];
      for (var note in notes) {
        if ((note.title == null || note.title!.isEmpty) &&
            (note.desc == null || note.desc!.isEmpty)) {
          await _repository.deleteNote(note.id);
        } else {
          validNotes.add(note);
        }
      }

      emit(
        _applyFilters(
          state.copyWith(status: NoteStatus.success, allNotes: validNotes),
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: NoteStatus.error, message: e.toString()));
    }
  }

  Future<void> _onLoadListNoteByMatkul(
    LoadListNoteByMatkul event,
    Emitter<NoteState> emit,
  ) async {
    emit(state.copyWith(status: NoteStatus.loading));
    try {
      final notes = _repository.getNotesByMatkul(event.matkulId);
      emit(state.copyWith(status: NoteStatus.success, filteredNotes: notes));
    } catch (e) {
      emit(state.copyWith(status: NoteStatus.error, message: e.toString()));
    }
  }

  Future<void> _onLoadNote(LoadNote event, Emitter<NoteState> emit) async {
    // If we already have it selected, just ensure success
    if (state.selectedNote?.id == event.id) {
      emit(state.copyWith(status: NoteStatus.success, lastLoadedId: event.id));
      return;
    }

    // Optimization: If we have it in list, set it immediately
    final existing = state.allNotes.where((n) => n.id == event.id).firstOrNull;
    if (existing != null) {
      emit(
        state.copyWith(
          selectedNote: existing,
          status: NoteStatus.success,
          lastLoadedId: event.id,
        ),
      );
      return;
    }

    // Otherwise, clear and load from repository
    emit(
      state.copyWith(
        status: NoteStatus.loading,
        clearSelected: true,
        lastLoadedId: event.id,
      ),
    );
    try {
      final note = _repository.getNoteById(event.id);
      emit(
        state.copyWith(
          status: NoteStatus.success,
          selectedNote: note,
          lastLoadedId: event.id,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: NoteStatus.error, message: e.toString()));
    }
  }

  Future<void> _onAddNote(AddNote event, Emitter<NoteState> emit) async {
    try {
      await _repository.addNote(event.note);
      add(LoadListNote());
    } catch (e) {
      emit(state.copyWith(status: NoteStatus.error, message: e.toString()));
    }
  }

  Future<void> _onUpdateNote(UpdateNote event, Emitter<NoteState> emit) async {
    try {
      await _repository.updateNote(event.note);
      final notes = _repository.getAllNote();

      final updatedAllNotes = notes
          .map((n) => n.id == event.note.id ? event.note : n)
          .toList();

      final newState = state.copyWith(
        allNotes: updatedAllNotes,
        selectedNote: event.note,
        status: NoteStatus.success,
      );
      emit(_applyFilters(newState));
    } catch (e) {
      emit(state.copyWith(status: NoteStatus.error, message: e.toString()));
    }
  }

  Future<void> _onDeleteNote(DeleteNote event, Emitter<NoteState> emit) async {
    try {
      await _repository.deleteNote(event.id);
      add(LoadListNote());
    } catch (e) {
      emit(state.copyWith(status: NoteStatus.error, message: e.toString()));
    }
  }

  Future<void> _onDeleteAllNote(
    DeleteAllNote event,
    Emitter<NoteState> emit,
  ) async {
    try {
      await _repository.deleteAllNote();
      add(LoadListNote());
    } catch (e) {
      emit(state.copyWith(status: NoteStatus.error, message: e.toString()));
    }
  }

  void _onSearchNotes(SearchNotes event, Emitter<NoteState> emit) {
    emit(_applyFilters(state.copyWith(searchQuery: event.query)));
  }

  void _onFilterNotesByMatkul(
    FilterNotesByMatkul event,
    Emitter<NoteState> emit,
  ) {
    emit(_applyFilters(state.copyWith(filterMatkulId: event.matkulId)));
  }

  void _onSortNotes(SortNotes event, Emitter<NoteState> emit) {
    emit(
      _applyFilters(
        state.copyWith(
          sortActiveIndex: event.activeIndex,
          isAsce: event.isAsce,
          isSortByCreatedDate: event.isSortByCreatedDate,
        ),
      ),
    );
  }
}
