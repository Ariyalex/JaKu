import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jaku/data/models/note.dart';
import 'package:jaku/modules/note/bloc/note_bloc.dart';
import 'package:jaku/modules/note/bloc/note_event.dart';
import 'package:jaku/modules/note/bloc/note_state.dart';
import 'package:jaku/core/routes/route_named.dart';
import 'package:jaku/core/widgets/note_global.dart';
import 'package:jaku/modules/task/view/task_dashboard.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:go_router/go_router.dart';

class NoteMatkul extends HookWidget {
  const NoteMatkul({super.key, required this.matkulId});

  final String matkulId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    useEffect(() {
      context.read<NoteBloc>().add(LoadListNoteByMatkul(matkulId));
      return;
    }, [matkulId]);

    return BlocBuilder<NoteBloc, NoteState>(
      builder: (context, state) {
        if (state is NoteListByMatkulLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is NoteListByMatkulLoaded) {
          final notes = state.notes;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Catatan",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(LucideIcons.plus),
                    tooltip: "Tambah Catatan",
                    onPressed: () {
                      final newNoteId = uuid.v4();
                      context.read<NoteBloc>().add(
                        AddNote(
                          Note(
                            id: newNoteId,
                            createdOn: DateTime.now(),
                            editedOn: DateTime.now(),
                          ),
                        ),
                      );
                      context.pushNamed(RouteNamed.addNote, extra: newNoteId);
                    },
                  ),
                ],
              ),
              notes.isEmpty
                  ? Text(
                      "Belum ada catatan.",
                      style: theme.textTheme.bodyMedium,
                    )
                  : NoteGlobal(showMatkul: false, notes: notes),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
