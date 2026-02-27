import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jaku/data/repositories/note_repositoruy.dart';
import 'package:jaku/modules/note/bloc/note_event.dart';
import 'package:jaku/modules/note/bloc/note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final NoteRepository _repository;
  NoteBloc(this._repository) : super(NoteInitial()) {
    on<LoadListNote>(_onLoadListNote);

    on<LoadListNoteByMatkul>(_onLoadListNoteByMatkul);

    on<LoadNote>(_onLoadNote);

    on<AddNote>(_onAddNote);

    on<UpdateNote>(_onUpdateNote);

    on<DeleteNote>(_onDeleteNote);

    on<DeleteAllNote>(_onDeleteAllNote);
  }

  Future<void> _onLoadListNote(
    LoadListNote event,
    Emitter<NoteState> emit,
  ) async {
    emit(NoteListLoading());
    try {
      final notes = _repository.getAllNote();
      emit(NoteListLoaded(notes));
    } catch (e) {
      emit(NoteError(e.toString()));
    }
  }

  Future<void> _onLoadListNoteByMatkul(
    LoadListNoteByMatkul event,
    Emitter<NoteState> emit,
  ) async {
    emit(NoteListByMatkulLoading());
    try {
      final notes = _repository.getNotesByMatkul(event.matkulId);
      emit(NoteListByMatkulLoaded(notes));
    } catch (e) {
      emit(NoteError(e.toString()));
    }
  }

  Future<void> _onLoadNote(LoadNote event, Emitter<NoteState> emit) async {
    emit(NoteLoading());
    try {
      final note = _repository.getNoteById(event.id);
      emit(NoteLoaded(note));
    } catch (e) {
      emit(NoteError(e.toString()));
    }
  }

  Future<void> _onAddNote(AddNote event, Emitter<NoteState> emit) async {
    try {
      await _repository.addNote(event.note);
      add(LoadListNote());
    } catch (e) {
      emit(NoteError(e.toString()));
    }
  }

  Future<void> _onUpdateNote(UpdateNote event, Emitter<NoteState> emit) async {
    try {
      await _repository.updateNote(event.note);
      add(LoadListNote());
    } catch (e) {
      emit(NoteError(e.toString()));
    }
  }

  Future<void> _onDeleteNote(DeleteNote event, Emitter<NoteState> emit) async {
    try {
      await _repository.deleteNote(event.id);
      add(LoadListNote());
    } catch (e) {
      emit(NoteError(e.toString()));
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
      emit(NoteError(e.toString()));
    }
  }
}
