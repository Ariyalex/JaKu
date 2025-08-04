import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:jaku/models/note.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class NoteMatkul extends StatelessWidget {
  const NoteMatkul({
    super.key,
    required this.theme,
    required this.notes,
  });

  final ThemeData theme;
  final List<Note> notes;

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
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(LucideIcons.plus),
              tooltip: "Tambah Catatan",
              onPressed: () {
                // TODO: Tambah note
              },
            ),
          ],
        ),
        notes.isEmpty
            ? Text("Belum ada catatan.", style: theme.textTheme.bodyMedium)
            : MasonryGridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: notes.length,
                gridDelegate:
                    const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: theme.dividerColor, width: 1.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (note.title != null)
                              Text(
                                note.title!,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            const SizedBox(height: 6),
                            if (note.desc != null || note.desc != "")
                              Text(
                                note.desc!,
                                style: theme.textTheme.bodySmall,
                              )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ],
    );
  }
}
