import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaku/controllers/note_controllers/note_controllers.dart';
import 'package:jaku/widgets/note_widgets/select_matkul_widget.dart';

class AddNote extends StatefulWidget {
  const AddNote({super.key});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final noteC = Get.find<NoteControllers>();
  String noteId = Get.arguments;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      noteC.titleC.addListener(() => noteC.onNoteChanged(noteId));
      noteC.noteC.addListener(() => noteC.onNoteChanged(noteId));
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    final note = noteC.selectById(noteId);
    if (note != null &&
        (note.matkul?.isEmpty ?? true) &&
        (note.title?.isEmpty ?? true)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        noteC.deleteNote(noteId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SelectMatkulWidget(noteId: noteId),
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
