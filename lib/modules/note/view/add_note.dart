import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:jaku/data/entities/note.dart';
import 'package:jaku/modules/note/bloc/note_bloc.dart';
import 'package:jaku/modules/note/bloc/note_event.dart';
import 'package:jaku/core/widgets/select_matkul_widget.dart';

class AddNote extends HookWidget {
  const AddNote({super.key});

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
    
    // Track if the note has been saved at least once
    final isSaved = useRef<bool>(false);

    useEffect(() {
      Timer? debounceTimer;

      void saveNote() {
        // Only save if there is some content
        if (titleController.text.isEmpty && noteController.text.isEmpty) return;

        final updatedNote = initialNote.copyWith(
          title: titleController.text,
          desc: noteController.text,
          editedOn: DateTime.now(),
          matkulId: selectedMatkulId.value,
        );

        noteBloc.add(UpdateNote(updatedNote));
        isSaved.value = true;
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

        // If the screen is disposed and content is empty, but we had saved it before, delete it.
        if (isSaved.value && titleController.text.isEmpty && noteController.text.isEmpty) {
          noteBloc.add(DeleteNote(initialNote.id));
        }
      };
    }, [titleController, noteController, selectedMatkulId.value]);

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
