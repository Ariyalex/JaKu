import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:jaku/data/entities/note.dart';
import 'package:jaku/modules/note/bloc/note_bloc.dart';
import 'package:jaku/modules/note/bloc/note_event.dart';
import 'package:jaku/modules/note/bloc/note_state.dart';
import 'package:jaku/core/utils/snackbar_widget.dart';
import 'package:jaku/core/widgets/select_matkul_widget.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class DetailNote extends HookWidget {
  const DetailNote({super.key, this.noteId});
  
  final String? noteId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final noteBloc = context.read<NoteBloc>();
    
    // Read from route extra if not passed via constructor
    final String? id = noteId ?? (GoRouterState.of(context).extra as String?);

    final noteState = context.watch<NoteBloc>().state;
    
    useEffect(() {
      if (id != null) {
        noteBloc.add(LoadNote(id));
      }
      return null;
    }, [id]);

    final existingNote = noteState.selectedNote;

    final selectedMatkulId = useState<String?>(null);
    final titleController = useTextEditingController();
    final noteController = useTextEditingController();

    useEffect(() {
      if (existingNote != null && existingNote.id == id) {
        titleController.text = existingNote.title ?? '';
        noteController.text = existingNote.desc ?? '';
        selectedMatkulId.value = existingNote.matkulId;
      }
      return null;
    }, [existingNote]);

    useEffect(() {
      Timer? debounceTimer;

      void saveNote() {
        if (id == null) return;
        
        final newNote = Note(
          id: id,
          title: titleController.text,
          desc: noteController.text,
          createdOn: existingNote?.createdOn ?? DateTime.now(),
          editedOn: DateTime.now(),
          matkulId: selectedMatkulId.value,
        );

        noteBloc.add(UpdateNote(newNote));
      }

      void onTextChanged() {
        if (debounceTimer?.isActive ?? false) debounceTimer!.cancel();
        debounceTimer = Timer(const Duration(milliseconds: 300), saveNote);
      }

      titleController.addListener(onTextChanged);
      noteController.addListener(onTextChanged);

      return () {
        titleController.removeListener(onTextChanged);
        noteController.removeListener(onTextChanged);
        if (debounceTimer?.isActive ?? false) debounceTimer!.cancel();
      };
    }, [titleController, noteController, selectedMatkulId.value, existingNote]);

    void deleteNote() {
      if (id != null) {
        try {
          noteBloc.add(DeleteNote(id));
          context.pop(); // Close dialog
          context.pop(); // Go back from detail
          showAppSnackbar(title: "Success", message: "Berhasil menghapus note");
        } catch (e) {
          showAppSnackbar(
            title: "Error!",
            message: "Error ketika menghapus note: $e",
            isSuccess: false,
          );
        }
      }
    }

    if (existingNote == null && noteState.status == NoteStatus.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SelectMatkulWidget(
              matkulId: selectedMatkulId.value,
              onChanged: (val) {
                selectedMatkulId.value = val;
              },
            ),
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Hapus note?", style: TextStyle(fontWeight: FontWeight.bold)),
                  backgroundColor: theme.dialogTheme.backgroundColor,
                  content: const Text(
                    "Yakin ingin menghapus note ini?",
                    textAlign: TextAlign.center,
                  ),
                  actions: [
                    FilledButton(
                      onPressed: () {
                        context.pop();
                      },
                      child: const Text("Tidak"),
                    ),
                    OutlinedButton(
                      onPressed: deleteNote,
                      child: const Text("Ya"),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(LucideIcons.trash2),
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
                controller: titleController,
                minLines: 1,
                maxLines: null,
                style: theme.textTheme.titleLarge,
                decoration: InputDecoration(
                  hintText: 'Title',
                  hintStyle: theme.textTheme.titleLarge,
                  border: InputBorder.none,
                  filled: false,
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: noteController,
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
