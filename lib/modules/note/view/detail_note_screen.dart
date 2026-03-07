import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:jaku/modules/matkul/bloc/matkul_bloc.dart';
import 'package:jaku/modules/matkul/bloc/matkul_event.dart';
import 'package:jaku/modules/matkul/bloc/matkul_state.dart';
import 'package:jaku/modules/note/bloc/note_bloc.dart';
import 'package:jaku/modules/note/bloc/note_event.dart';
import 'package:jaku/modules/note/bloc/note_state.dart';
import 'package:jaku/core/utils/snackbar_widget.dart';
import 'package:jaku/core/widgets/select_matkul_widget.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class DetailNoteScreen extends HookWidget {
  const DetailNoteScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final noteBloc = context.read<NoteBloc>();
    final matkulBloc = context.read<MatkulBloc>();

    // Mendengarkan perubahan state
    final noteState = context.watch<NoteBloc>().state;

    final titleController = useTextEditingController();
    final noteController = useTextEditingController();
    final selectedMatkulId = useState<String?>(null);
    
    // Track ID yang sedang ditampilkan di controller
    final displayedId = useRef<String?>(null);

    // 1. Initial Load
    useEffect(() {
      noteBloc.add(LoadNote(id));
      // Pastikan matkul dimuat jika belum
      if (matkulBloc.state.status == MatkulStatus.initial) {
        matkulBloc.add(LoadListMatkul());
      }
      return null;
    }, [id]);

    // 2. Sinkronisasi data ke controller jika data sudah benar
    useEffect(() {
      if (noteState.status == NoteStatus.success && noteState.lastLoadedId == id) {
        final note = noteState.selectedNote;
        if (note != null && displayedId.value != id) {
          titleController.text = note.title ?? '';
          noteController.text = note.desc ?? '';
          selectedMatkulId.value = note.matkulId;
          displayedId.value = id;
        }
      }
      return null;
    }, [noteState.status, noteState.selectedNote, noteState.lastLoadedId, id]);

    // 3. Auto-Save Logic
    final debounceTimer = useRef<Timer?>(null);

    // Function untuk mentrigger save dengan debouncing
    final triggerSave = useCallback(() {
      if (noteState.selectedNote == null || noteState.selectedNote!.id != id) return;

      final updatedNote = noteState.selectedNote!.copyWith(
        title: titleController.text,
        desc: noteController.text,
        editedOn: DateTime.now(),
        matkulId: selectedMatkulId.value,
      );

      // Hanya save jika ada perubahan nyata dari data di state
      final currentNote = noteState.selectedNote!;
      if (updatedNote.title != currentNote.title ||
          updatedNote.desc != currentNote.desc ||
          updatedNote.matkulId != currentNote.matkulId) {
        
        if (debounceTimer.value?.isActive ?? false) debounceTimer.value!.cancel();
        debounceTimer.value = Timer(const Duration(milliseconds: 300), () {
          noteBloc.add(UpdateNote(updatedNote));
        });
      }
    }, [noteState.selectedNote, id, titleController, noteController, selectedMatkulId.value, noteBloc]);

    // Listener untuk text changes
    useEffect(() {
      titleController.addListener(triggerSave);
      noteController.addListener(triggerSave);
      return () {
        titleController.removeListener(triggerSave);
        noteController.removeListener(triggerSave);
      };
    }, [titleController, noteController, triggerSave]);

    // Listener untuk matkul change
    useEffect(() {
      if (displayedId.value == id) {
        triggerSave();
      }
      return null;
    }, [selectedMatkulId.value]);

    void deleteNote() {
      try {
        noteBloc.add(DeleteNote(id));
        context.pop();
        context.pop();
        showAppSnackbar(title: "Success", message: "Berhasil menghapus note");
      } catch (e) {
        showAppSnackbar(
          title: "Error!",
          message: "Gagal menghapus note: $e",
          isSuccess: false,
        );
      }
    }

    // Logic Loading yang lebih fleksibel
    final isNoteLoading = noteState.status == NoteStatus.loading || noteState.lastLoadedId != id;

    if (isNoteLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Tampilan jika data tidak ditemukan
    if (noteState.selectedNote == null) {
      return const Scaffold(body: Center(child: Text("Catatan tidak ditemukan")));
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
                  title: const Text(
                    "Hapus note?",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: theme.dialogTheme.backgroundColor,
                  content: const Text(
                    "Yakin ingin menghapus note ini?",
                    textAlign: TextAlign.center,
                  ),
                  actions: [
                    FilledButton(
                      onPressed: () => context.pop(),
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
