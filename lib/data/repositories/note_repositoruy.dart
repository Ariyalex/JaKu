import 'package:jaku/data/models/note.dart';
import 'package:jaku/data/providers/local_note_provider.dart';

class NoteRepository {
  final LocalNoteProvider _localProvider;
  NoteRepository(this._localProvider);

  List<Note> getAllNote() {
    try {
      return _localProvider.getAllNote();
    } catch (e) {
      print("error get all note(repo): $e");
      rethrow;
    }
  }

  List<Note> getNotesByMatkul(String matkulId) {
    try {
      return _localProvider.getNotesByMatkul(matkulId);
    } catch (e) {
      print("error get all note(repo): $e");
      rethrow;
    }
  }

  Note getNoteById(String id) {
    try {
      final result = _localProvider.getNoteById(id);
      if (result == null) throw Exception("Note tidak ditemukan");
      return result;
    } catch (e) {
      print("error get matkul(repo): $e");
      rethrow;
    }
  }

  Future<void> addNote(Note note) async {
    try {
      await _localProvider.saveNote(note);
    } catch (e) {
      print("error save note(repo): $e");
      rethrow;
    }
  }

  Future<void> addNotes(List<Note> notes) async {
    try {
      await _localProvider.saveNotes(notes);
    } catch (e) {
      print("error save notes: $e");
      rethrow;
    }
  }

  Future<void> updateNote(Note note) async {
    try {
      final getNote = _localProvider.getNoteById(note.id);
      if (getNote == null) throw Exception("Note tidak ditemukan");
      await _localProvider.saveNote(note);
    } catch (e) {
      print("error update note: $e");
      rethrow;
    }
  }

  Future<void> deleteNote(String id) async {
    try {
      final getMatkul = _localProvider.getNoteById(id);
      if (getMatkul == null) throw Exception("Note tidak ditemukan");
      await _localProvider.deleteNote(id);
    } catch (e) {
      print("error delete note: $e");
      rethrow;
    }
  }

  Future<void> deleteAllNote() async {
    try {
      await _localProvider.deleteAllNote();
    } catch (e) {
      print("error delete all note: $e");
      rethrow;
    }
  }
}
