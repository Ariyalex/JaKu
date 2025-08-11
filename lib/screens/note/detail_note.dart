import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaku/controllers/note_controllers/note_controllers.dart';
import 'package:jaku/models/note.dart';
import 'package:jaku/widgets/note_widgets/note_global.dart';
import 'package:jaku/widgets/note_widgets/select_matkul_widget.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class DetailNote extends StatefulWidget {
  const DetailNote({super.key});

  @override
  State<DetailNote> createState() => _DetailNoteState();
}

class _DetailNoteState extends State<DetailNote> {
  final noteC = Get.find<NoteControllers>();
  late Note? selectedNote;
  final noteId = Get.arguments;

  @override
  void initState() {
    super.initState();
    // Ambil selectedNote dari widget atau dari Get.arguments
    selectedNote = noteC.selectById(noteId);
    noteC.titleC.text = selectedNote?.title ?? '';
    noteC.noteC.text = selectedNote?.desc ?? '';
    noteC.matkulC.value = selectedNote?.matkul ?? '';
    noteC.titleC.addListener(() => noteC.onNoteChanged(noteId));
    noteC.noteC.addListener(() => noteC.onNoteChanged(noteId));
    noteC.matkulC.listen((_) => noteC.onNoteChanged(noteId));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SelectMatkulWidget(
              selectedMatkul: getInitials(selectedNote?.matkul ?? ""),
              noteId: noteId,
            ),
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
