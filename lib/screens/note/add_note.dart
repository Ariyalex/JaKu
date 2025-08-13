import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaku/controllers/matkul_controllers/jadwal_kuliah_c.dart';
import 'package:jaku/controllers/note_controllers/note_controllers.dart';
import 'package:jaku/models/matkul.dart';
import 'package:jaku/widgets/note_widgets/select_matkul_widget.dart';

class AddNote extends StatefulWidget {
  const AddNote({super.key});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final noteC = Get.find<NoteControllers>();
  final matkulC = Get.find<JadwalkuliahC>();

  late final StreamSubscription _matkulSub;
  String? noteId;
  late Matkul? selectedMatkul;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    selectedMatkul = Get.arguments;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      noteC.titleC.addListener(_onAnyChanged);
      noteC.noteC.addListener(_onAnyChanged);
      _matkulSub = noteC.matkulC.listen((_) => _onAnyChanged());
    });
  }

  void _onAnyChanged() {
    noteId ??= noteC.addNote();
    noteC.onNoteChanged(noteId!, matkulC);
  }

  @override
  void dispose() {
    noteC.titleC.removeListener(_onAnyChanged);
    noteC.noteC.removeListener(_onAnyChanged);
    _matkulSub.cancel();
    if (noteId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        noteC.matkulC.value = "";
        noteC.titleC.clear();
        noteC.noteC.clear();

        final note = noteC.selectById(noteId!);
        if (note != null &&
            (note.desc?.isEmpty ?? true) &&
            (note.title?.isEmpty ?? true)) {
          noteC.deleteNote(noteId!);
        }
      });
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: selectedMatkul == null
                ? SelectMatkulWidget()
                : SelectMatkulWidget(matkulId: selectedMatkul!.id),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: noteC.titleC,
                style: theme.textTheme.titleLarge,
                minLines: 1,
                maxLines: null, // expands vertically when overflow
                decoration: InputDecoration(
                  hintText: 'Title',
                  hintStyle: theme.textTheme.titleLarge,
                  border: InputBorder.none,
                  filled: false,
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: noteC.noteC,
                  style: theme.textTheme.bodyMedium,
                  decoration: InputDecoration(
                    hintText: 'Note',
                    hintStyle: theme.textTheme.bodyMedium,
                    border: InputBorder.none,
                    filled: false,
                    contentPadding: EdgeInsets.zero,
                  ),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
