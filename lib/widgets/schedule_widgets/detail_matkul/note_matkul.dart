import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaku/models/note.dart';
import 'package:jaku/routes/route_named.dart';
import 'package:jaku/widgets/note_widgets/note_global.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class NoteMatkul extends StatelessWidget {
  const NoteMatkul({
    super.key,
    required this.theme,
    required this.notes,
    required this.matkul,
  });

  final ThemeData theme;
  final List<Note> notes;
  final String matkul;

  @override
  Widget build(BuildContext context) {
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
                // TODO: Tambah note
                print(matkul);
                Get.toNamed(RouteNamed.addNote, arguments: matkul);
              },
            ),
          ],
        ),
        notes.isEmpty
            ? Text("Belum ada catatan.", style: theme.textTheme.bodyMedium)
            : NoteGlobal(showMatkul: false),
      ],
    );
  }
}
