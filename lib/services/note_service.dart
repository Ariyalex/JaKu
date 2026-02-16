import 'package:hive/hive.dart';
import 'package:jaku/data/models/note.dart';

class NoteService {
  static const noteBoxName = "note_box";

  //init hive
  static Future<void> initNoteService() async {
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(NoteAdapter());
    }
    await Hive.openBox<Note>(noteBoxName);
  }

  //get reference to the box
  static Box<Note> getNoteBox() {
    return Hive.box<Note>(noteBoxName);
  }

  //save single note
  static Future<void> saveNoteService(Note note) async {
    final box = getNoteBox();

    if (note.id != null) {
      await box.put(note.id, note);
    } else {
      throw Exception("note id kosong");
    }
  }

  //save multiple note
  static Future<void> saveAllNoteService(List<Note> notes) async {
    final box = getNoteBox();

    final Map<dynamic, Note> noteMap = {};

    for (var note in notes) {
      if (note.id != null) {
        noteMap[note.id] = note;
      } else {
        throw Exception("note id kosong");
      }
    }
    await box.putAll(noteMap);
  }

  //get all saved notes
  static List<Note> getAllNoteService() {
    final box = getNoteBox();
    return box.values.toList();
  }

  //delete a note by
  static Future<void> deleteNoteService(String id) async {
    final box = getNoteBox();
    await box.delete(id);
  }

  //delete all notes
  static Future<void> deleteAllNoteService() async {
    final box = getNoteBox();
    await box.clear();
  }
}
