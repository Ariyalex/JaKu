import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:jaku/data/entities/note.dart';
import 'package:jaku/modules/note/bloc/note_bloc.dart';
import 'package:jaku/modules/note/bloc/note_event.dart';
import 'package:jaku/modules/note/widgets/select_matkul_widget.dart';

class AddNoteScreen extends HookWidget {
  const AddNoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final noteBloc = context.read<NoteBloc>();

    String? initialMatkulId;
    try {
      // Expecting a String? (matkulId) in extra
      initialMatkulId = GoRouterState.of(context).extra as String?;
    } catch (_) {}

    // Create a new note instance once when the screen is initialized
    final initialNote = useMemoized(
      () => Note.create(matkulId: initialMatkulId),
    );

    final selectedMatkulId = useState<String?>(initialNote.matkulId);
    final titleController = useTextEditingController();
    final noteController = useTextEditingController();

    // Track if the note has been added to the database at least once
    final isAddedToDb = useRef<bool>(false);

    useEffect(() {
      Timer? debounceTimer;

      void saveNote() {
        // If content is empty
        if (titleController.text.isEmpty && noteController.text.isEmpty) {
          // If it was previously saved, delete it from DB
          if (isAddedToDb.value) {
            noteBloc.add(DeleteNote(initialNote.id));
            isAddedToDb.value = false;
          }
          return;
        }

        final updatedNote = initialNote.copyWith(
          title: titleController.text,
          desc: noteController.text,
          editedOn: DateTime.now(),
          matkulId: selectedMatkulId.value,
        );

        if (!isAddedToDb.value) {
          // First time saving: use AddNote event
          noteBloc.add(AddNote(updatedNote));
          isAddedToDb.value = true;
        } else {
          // Subsequent saves: use UpdateNote event
          noteBloc.add(UpdateNote(updatedNote));
        }
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

        // Final check on dispose: if empty and was in DB, ensure it's deleted.
        if (isAddedToDb.value &&
            titleController.text.isEmpty &&
            noteController.text.isEmpty) {
          noteBloc.add(DeleteNote(initialNote.id));
        }
      };
    }, [titleController, noteController, selectedMatkulId.value]);

    useEffect(() {
      // Jangan simpan jika data belum pernah ada di DB dan teks masih kosong
      if (!isAddedToDb.value &&
          titleController.text.isEmpty &&
          noteController.text.isEmpty) {
        return;
      }

      // Langsung simpan saat Matkul berubah 🔄
      final updatedNote = initialNote.copyWith(
        title: titleController.text,
        desc: noteController.text,
        editedOn: DateTime.now(),
        matkulId: selectedMatkulId.value,
      );

      if (!isAddedToDb.value) {
        noteBloc.add(AddNote(updatedNote));
        isAddedToDb.value = true;
      } else {
        noteBloc.add(UpdateNote(updatedNote));
      }

      return null;
    }, [selectedMatkulId.value]);

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
                style: theme.textTheme.titleLarge,
                minLines: 1,
                maxLines: null,
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
