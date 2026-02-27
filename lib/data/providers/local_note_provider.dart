import 'package:hive_flutter/hive_flutter.dart';
import 'package:jaku/data/models/note.dart';

class LocalNoteProvider {
  Box<Note> get _noteBox => Hive.box<Note>("noteBox");

  List<Note> getAllNote() {
    try {
      return _noteBox.values.toList();
    } catch (e) {
      rethrow;
    }
  }

  List<Note> getNotesByMatkul(String matkulId) {
    try {
      final notes = _noteBox.values.toList();
      return notes.where((note) => note.matkulId == matkulId).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveNote(Note note) async {
    try {
      await _noteBox.put(note.id, note);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveNotes(List<Note> notes) async {
    try {
      for (var note in notes) {
        await _noteBox.put(note.id, note);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteAllNote() async {
    try {
      await _noteBox.clear();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteNote(String id) async {
    try {
      await _noteBox.delete(id);
    } catch (e) {
      rethrow;
    }
  }

  Note? getNoteById(String id) {
    try {
      return _noteBox.get(id);
    } catch (e) {
      rethrow;
    }
  }
}
