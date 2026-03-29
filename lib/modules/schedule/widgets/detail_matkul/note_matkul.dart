import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jaku/modules/note/bloc/note_bloc.dart';
import 'package:jaku/modules/note/bloc/note_event.dart';
import 'package:jaku/modules/note/bloc/note_state.dart';
import 'package:jaku/core/routes/route_named.dart';
import 'package:jaku/core/widgets/note_global.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:go_router/go_router.dart';

class NoteMatkul extends HookWidget {
  const NoteMatkul({super.key, required this.matkulId});

  final String matkulId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final noteBloc = context.read<NoteBloc>();

    useEffect(() {
      noteBloc.add(LoadListNoteByMatkul(matkulId));
      return;
    }, [matkulId]);

    return BlocBuilder<NoteBloc, NoteState>(
      bloc: noteBloc,
      builder: (context, state) {
        if (state.status == NoteStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        final notes = state.filteredNoteByMatkul;
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
                  onPressed: () async {
                    await context.pushNamed(
                      RouteNamed.addNote,
                      extra: matkulId,
                    );

                    noteBloc.add(LoadListNoteByMatkul(matkulId));
                  },
                ),
              ],
            ),
            notes.isEmpty
                ? Text("Belum ada catatan.", style: theme.textTheme.bodyMedium)
                : NoteGlobal(showMatkul: false, notes: notes),
          ],
        );
      },
    );
  }
}
