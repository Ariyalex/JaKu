import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaku/controllers/matkul_controllers/jadwal_kuliah_c.dart';
import 'package:jaku/controllers/note_controllers/note_controllers.dart';
import 'package:jaku/models/note.dart';
import 'package:jaku/widgets/note_widgets/select_matkul_widget.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class DetailNote extends StatefulWidget {
  const DetailNote({super.key});

  @override
  State<DetailNote> createState() => _DetailNoteState();
}

class _DetailNoteState extends State<DetailNote> {
  final noteC = Get.find<NoteControllers>();
  final matkulC = Get.find<JadwalkuliahC>();
  late Note? selectedNote;
  late final StreamSubscription _matkulSub;
  final noteId = Get.arguments;

  @override
  void initState() {
    super.initState();
    // Ambil selectedNote dari widget atau dari Get.arguments
    selectedNote = noteC.selectById(noteId);
    noteC.titleC.text = selectedNote?.title ?? '';
    noteC.noteC.text = selectedNote?.desc ?? '';
    noteC.matkulC.value = selectedNote?.matkul ?? '';

    noteC.titleC.addListener(_onAnyChanged);
    noteC.noteC.addListener(_onAnyChanged);
    _matkulSub = noteC.matkulC.listen(
      (_) => noteC.onNoteChanged(noteId, matkulC),
    );
  }

  void _onAnyChanged() {
    noteC.onNoteChanged(noteId!, matkulC);
  }

  @override
  void dispose() {
    noteC.titleC.removeListener(_onAnyChanged);
    noteC.noteC.removeListener(_onAnyChanged);
    _matkulSub.cancel();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      noteC.matkulC.value = "";
      noteC.titleC.clear();
      noteC.noteC.clear();
    });

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SelectMatkulWidget(matkulId: selectedNote?.matkulId ?? ""),
          ),
          IconButton(
            onPressed: () {
              noteC.deleteNote(noteId);
              Get.back();
            },
            icon: Icon(LucideIcons.trash2),
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
                minLines: 1,
                maxLines: null, // expands vertically when overflow
                style: theme.textTheme.titleLarge,
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
