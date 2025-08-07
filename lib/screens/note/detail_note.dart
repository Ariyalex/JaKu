import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  late Note selectedNote;

  @override
  void initState() {
    super.initState();
    // Ambil selectedNote dari widget atau dari Get.arguments
    selectedNote = Get.arguments as Note;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleC = TextEditingController(text: selectedNote.title);
    final noteC = TextEditingController(text: selectedNote.desc);

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SelectMatkulWidget(
              selectedMatkul: getInitials(selectedNote.matkul ?? ""),
            ),
          ),
          IconButton(onPressed: () {}, icon: Icon(LucideIcons.trash2)),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: titleC,
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
                  controller: noteC,
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
