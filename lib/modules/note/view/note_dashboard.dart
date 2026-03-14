import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:jaku/modules/note/bloc/note_bloc.dart';
import 'package:jaku/modules/note/bloc/note_state.dart';
import 'package:jaku/core/routes/route_named.dart';
import 'package:jaku/core/widgets/note_global.dart';
import 'package:jaku/modules/note/widgets/search_textfield.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class NoteDashboard extends HookWidget {
  const NoteDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: BlocBuilder<NoteBloc, NoteState>(
        builder: (context, state) {
          if (state.status == NoteStatus.initial ||
              state.status == NoteStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          final notes = state.filteredNotes;

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                spacing: 12,
                children: [
                  SearchTextfield(),
                  Expanded(
                    child: notes.isNotEmpty
                        ? NoteGlobal(notes: notes)
                        : Center(
                            child: Column(
                              children: [
                                Text(
                                  "Tidak ada note",
                                  style: theme.textTheme.bodyLarge,
                                ),
                                Container(
                                  margin: const EdgeInsets.all(12),
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Image.asset("images/malas.gif"),
                                ),
                              ],
                            ),
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context.pushNamed(RouteNamed.addNote);
        },
        shape: const CircleBorder(),
        child: const Icon(LucideIcons.plus),
      ),
    );
  }
}
