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

  //controller for sorting
  RxBool isSortByCreatedDate = true.obs;
  RxInt activeIndex = 0.obs;
  RxBool isAsce = true.obs;
  RxBool isSorting = false.obs;

  //controller for filtering
  RxString filterMatkulId = "all".obs;
  RxList<Note> filteredNotes = <Note>[].obs;

  //controller filter

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
      filterByMatkul();
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

      //sorting note
      if (isSortByCreatedDate.value && isAsce.value) {
        sortByCreatedAsc();
      } else if (isSortByCreatedDate.value && !isAsce.value) {
        sortByCreatedDesc();
      } else if (!isSortByCreatedDate.value && isAsce.value) {
        sortByEditedAsc();
      } else if (!isSortByCreatedDate.value && !isAsce.value) {
        sortByEditedDesc();
      }

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

      //sorting note
      if (isSortByCreatedDate.value && isAsce.value) {
        sortByCreatedAsc();
      } else if (isSortByCreatedDate.value && !isAsce.value) {
        sortByCreatedDesc();
      } else if (!isSortByCreatedDate.value && isAsce.value) {
        sortByEditedAsc();
      } else if (!isSortByCreatedDate.value && !isAsce.value) {
        sortByEditedDesc();
      }
    } catch (error) {
      print("error updating note: $error");
      rethrow;
    }
  }

  Future<void> deleteMatkulRelationFromNotes() async {
    try {
      final allMatkul = Get.find<JadwalkuliahC>().allMatkul;
      final validMatkulIds = allMatkul.map((matkul) => matkul.id).toSet();
      for (final matkul in allMatkul) {
        print('Matkul ID: ${matkul.id}');
      }

      // Update notes yang matkulId-nya tidak valid: hapus relasi matkul
      final notesToUpdate = allNote
          .where(
            (note) =>
                note.matkulId != null &&
                !validMatkulIds.contains(note.matkulId),
          )
          .toList();

      for (var note in notesToUpdate) {
        print("note matkul id: ${note.matkulId}");
      }

      for (final note in notesToUpdate) {
        final updatedNote = note.copyWith(matkulId: null, matkul: null);

        int index = allNote.indexOf(note);
        if (index != -1) {
          allNote[index] = updatedNote; // langsung update RxList
          await NoteService.saveNoteService(updatedNote);
        }
      }

      // Refresh RxList dari Hive jika perlu
      loadAllNotes();

      print("complete delete matkul relation");
    } catch (error) {
      print(error);

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

  void sortByCreatedAsc() {
    try {
      allNote.sort((a, b) => a.createdOn.compareTo(b.createdOn));
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  void sortByCreatedDesc() {
    try {
      allNote.sort((a, b) => b.createdOn.compareTo(a.createdOn));
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  void sortByEditedAsc() {
    try {
      allNote.sort((a, b) => b.editedOn.compareTo(a.editedOn));
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  void sortByEditedDesc() {
    try {
      allNote.sort((a, b) => a.editedOn.compareTo(b.editedOn));
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  void filterByMatkul() {
    try {
      if (filterMatkulId.value == "all") {
        filteredNotes.clear();
        filteredNotes.addAll(allNote);
      } else if (filterMatkulId.value == "umum") {
        filteredNotes.clear();
        filteredNotes.addAll(
          allNote.where((note) => note.matkulId == null || note.matkulId == ""),
        );
      } else {
        filteredNotes.clear();
        filteredNotes.addAll(
          allNote.where((note) => note.matkulId == filterMatkulId.value),
        );
      }
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  @override
  void onInit() async {
    // TODO: implement onInit

    super.onInit();
    print("run loading");
    isLoading.value = true;
    loadAllNotes();
    await deleteMatkulRelationFromNotes();
    filterByMatkul();
    isLoading.value = false;
    print("loading complete");
  }

  //dispose debaunce when onclose
  @override
  void onClose() {
    // TODO: implement onClose
    debounce?.cancel();
    super.onClose();
  }
}
