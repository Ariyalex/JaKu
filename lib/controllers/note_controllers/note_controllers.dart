import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jaku/controllers/matkul_controllers/jadwal_kuliah_c.dart';
import 'package:jaku/models/matkul.dart';
import 'package:jaku/models/note.dart';
import 'package:jaku/services/note_service.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();

class NoteControllers extends GetxController {
  final titleC = TextEditingController();
  final noteC = TextEditingController();
  RxnString matkulC = RxnString(); //ini bersi matkul id
  RxBool isSortByCreatedDate = true.obs;

  //controller untuk sorting

  RxInt activeIndex = 0.obs;
  RxBool isAsce = true.obs;
  RxBool isSorting = false.obs;

  final RxBool isLoading = false.obs;

  final RxList<Note> allNote = <Note>[].obs;

  Timer? debounce;

  //save note debounce
  void onNoteChanged(String id, JadwalkuliahC jadwalKuliahC) {
    if (debounce?.isActive ?? false) debounce!.cancel();
    debounce = Timer(const Duration(milliseconds: 300), () {
      updateNote(id, jadwalKuliahC);
      final note = selectById(id);
      print("edited on: ${note!.editedOn}");
      print("debounce save");
    });
  }

  //select note by id
  Note? selectById(String id) {
    if (allNote.isEmpty) {
      debugPrint("data kosong, pastikan sudah memanggil getonce");
      return null;
    }
    return allNote.firstWhere(
      (element) => element.id == id,
      orElse: () => throw Exception("Matkul degnan ID $id tidak ditemukan"),
    );
  }

  //load all note and delete empty note
  void loadAllNotes() {
    isLoading.value = true;
    try {
      allNote.clear();

      final notes = NoteService.getAllNoteService();

      List<Note> noteList = [];
      for (var note in notes) {
        if ((note.title == null || note.title == "") &&
            (note.desc == null || note.desc == "")) {
          NoteService.deleteNoteService(note.id!);
        } else {
          noteList.add(note);
        }
      }

      allNote.value = noteList;
    } catch (error) {
      print("error load note: $error");
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  //add note with return note id
  String addNote() {
    try {
      Note newNote = Note(
        id: uuid.v4(),
        title: titleC.text,
        desc: noteC.text,
        createdOn: DateTime.now(),
        editedOn: DateTime.now(),
      );

      allNote.add(newNote);

      NoteService.saveNoteService(newNote);

      return newNote.id!;
    } catch (error) {
      print("error in adding note: $error");
      rethrow;
    }
  }

  //update note
  Future<void> updateNote(String id, JadwalkuliahC jadwalkuliahC) async {
    try {
      int index = allNote.indexWhere((note) => note.id == id);
      if (index == -1) return;

      final oldNote = allNote[index];

      // Update hanya field yang diubah, field lain tetap
      String? matkulId = matkulC.value;
      String? matkulName;
      if (matkulId != null && matkulId != "") {
        Matkul? selectedMatkul = jadwalkuliahC.selectMatkulById(matkulId);
        matkulName = selectedMatkul?.matkul;
      }

      final updatedNote = Note(
        id: oldNote.id,
        title: titleC.text,
        desc: noteC.text,
        createdOn: oldNote.createdOn, // tetap pakai createdOn lama
        editedOn: DateTime.now(),
        matkulId: matkulId ?? oldNote.matkulId,
        matkul: matkulName ?? oldNote.matkul,
        // tambahkan field lain jika ada
      );

      allNote[index] = updatedNote;
      await NoteService.saveNoteService(updatedNote);
    } catch (error) {
      print("error updating note: $error");
      rethrow;
    }
  }

  //delete note by id
  Future<void> deleteNote(String id) async {
    try {
      allNote.removeWhere((note) => note.id == id);

      await NoteService.deleteNoteService(id);
    } catch (error) {
      print("error deleting note: $error");
      rethrow;
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loadAllNotes();
  }

  //dispose debaunce when onclose
  @override
  void onClose() {
    // TODO: implement onClose
    debounce?.cancel();
    super.onClose();
  }
}
