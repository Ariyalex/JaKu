import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jaku/models/note.dart';
import 'package:jaku/services/note_service.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();

class NoteControllers extends GetxController {
  final titleC = TextEditingController();
  final noteC = TextEditingController();
  RxnString matkulC = RxnString();
  RxBool isSortByCreatedDate = true.obs;

  final RxBool isLoading = false.obs;

  final RxList<Note> allNote = <Note>[].obs;

  Timer? debounce;

  void onNoteChanged(String id) {
    if (debounce?.isActive ?? false) debounce!.cancel();
    debounce = Timer(const Duration(milliseconds: 300), () {
      updateNote(id);
    });
  }

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

  Future<void> loadAllNotes() async {
    isLoading.value = true;
    try {
      allNote.clear();
      allNote.value = NoteService.getAllNoteService();
    } catch (error) {
      print("error load note: $error");
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  String addNote() {
    try {
      Note newNote = Note(
        id: uuid.v4(),
        title: titleC.text,
        desc: noteC.text,
        createdOn: DateTime.now(),
        editedOn: DateTime.now(),
        matkul: matkulC.value,
      );

      allNote.add(newNote);

      NoteService.saveNoteService(newNote);

      return newNote.id!;
    } catch (error) {
      print("error in adding note: $error");
      rethrow;
    }
  }

  Future<void> updateNote(String id) async {
    try {
      Note updatedNote = Note(
        id: id,
        title: titleC.text,
        desc: noteC.text,
        editedOn: DateTime.now(),
        matkul: matkulC.value,
      );

      int index = allNote.indexWhere((note) => note.id == id);

      if (index != -1) {
        allNote[index] = updatedNote;
        await NoteService.saveNoteService(updatedNote);
      }
    } catch (error) {
      print("error updating note: $error");
      rethrow;
    }
  }

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
    super.onInit();
    NoteService.initNoteService();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    debounce?.cancel();
    super.onClose();
  }
}
