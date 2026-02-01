import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jaku/presentation/controllers/matkul_controllers.dart';
import 'package:jaku/domain/models/matkul.dart';
import 'package:jaku/domain/models/note.dart';
import 'package:jaku/application/services/note_service.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();

class NoteControllers extends GetxController {
  late TextEditingController titleC;
  late TextEditingController noteC;
  RxnString matkulC = RxnString(); //ini bersi matkul id

  //controller for sorting
  RxBool isSortByCreatedDate = true.obs;
  RxInt activeIndex = 0.obs;
  RxBool isAsce = true.obs;
  RxBool isSorting = false.obs;

  //controller for filtering
  RxString filterMatkulId = "all".obs;
  RxList<Note> filteredNotes = <Note>[].obs;

  //controller search
  final searchC = TextEditingController();

  final RxBool isLoading = false.obs;

  final RxList<Note> allNote = <Note>[].obs;

  Timer? debounce;

  ///save note with debounce
  void onNoteChanged(String id) {
    if (debounce?.isActive ?? false) debounce!.cancel();
    debounce = Timer(const Duration(milliseconds: 300), () {
      updateNote(id);
      final note = selectById(id);
      print("edited on: ${note!.editedOn}");
      print("debounce save");
      filterByMatkul();
    });
  }

  ///select note by id
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

  ///load all note and delete empty note
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

  ///add note with return note id
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

  ///update note by id
  Future<void> updateNote(String id) async {
    try {
      final matkulController = Get.find<MatkulController>();
      int index = allNote.indexWhere((note) => note.id == id);
      if (index == -1) return;

      final oldNote = allNote[index];

      // Update hanya field yang diubah, field lain tetap
      String? matkulId = matkulC.value;
      String? matkulName;
      if (matkulId != null && matkulId != "") {
        Matkul? selectedMatkul = matkulController.selectMatkulById(matkulId);
        matkulName = selectedMatkul?.name;
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

  ///delete matkul relation in allnotes
  Future<void> deleteMatkulRelationFromNotes() async {
    try {
      final allMatkul = Get.find<MatkulController>().allMatkul;
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

  ///delete note by id
  Future<void> deleteNote(String id) async {
    try {
      //delete note in allnotes and filteredNotes
      allNote.removeWhere((note) => note.id == id);
      filteredNotes.removeWhere((note) => note.id == id);

      await NoteService.deleteNoteService(id);
    } catch (error) {
      print("error deleting note: $error");
      rethrow;
    }
  }

  void sortByCreatedAsc() {
    try {
      filteredNotes.sort((a, b) => a.createdOn.compareTo(b.createdOn));
      print("srot by created asc");
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  void sortByCreatedDesc() {
    try {
      filteredNotes.sort((a, b) => b.createdOn.compareTo(a.createdOn));
      print("sort by created desc");
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  void sortByEditedAsc() {
    try {
      filteredNotes.sort((a, b) => b.editedOn.compareTo(a.editedOn));
      print("srot by edited asc");
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  void sortByEditedDesc() {
    try {
      filteredNotes.sort((a, b) => a.editedOn.compareTo(b.editedOn));
      print("srot by created desc");
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  void filterByMatkul() {
    try {
      final raw = filterMatkulId.value;
      if (raw.trim().isEmpty || raw == 'all') {
        filteredNotes
          ..clear()
          ..addAll(allNote);
        return;
      }

      final parts = raw
          .split(',')
          .map((e) => e.trim())
          .where((element) => element.isNotEmpty)
          .toList();
      final includeUmum = parts.contains('umum');
      final specificIds = parts.where((element) => element != 'umum').toSet();

      final result = allNote.where((note) {
        if (includeUmum && (note.matkulId == null || note.matkulId == ""))
          return true;
        if (specificIds.isNotEmpty && specificIds.contains(note.matkulId))
          return true;
        return false;
      }).toList();

      filteredNotes
        ..clear()
        ..addAll(result);
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  void searchNotes() {
    try {
      final lowerQuery = searchC.text.toLowerCase();
      filteredNotes.clear();
      filteredNotes.addAll(
        allNote.where((note) {
          final title = note.title?.toLowerCase() ?? '';
          final desc = note.desc?.toLowerCase() ?? '';
          return title.contains(lowerQuery) || desc.contains(lowerQuery);
        }),
      );
    } catch (error) {
      print("error searching notes: $error");
      rethrow;
    }
  }

  void onNoteSearch() {
    if (debounce?.isActive ?? false) debounce!.cancel();
    debounce = Timer(const Duration(milliseconds: 300), () {
      searchNotes();
      // filterByMatkul();
    });
  }

  @override
  void onInit() async {
    super.onInit();
    //init texteditingcontroller
    titleC = TextEditingController();
    noteC = TextEditingController();

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
    //dispose debounce
    debounce?.cancel();

    //dispose textEditingController
    titleC.dispose();
    noteC.dispose();
    super.onClose();
  }
}
