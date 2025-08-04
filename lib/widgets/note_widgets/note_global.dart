import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:jaku/models/note.dart';

class NoteGlobal extends StatelessWidget {
  const NoteGlobal({super.key, required this.notes});

  final List<Note> notes;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    String getInitials(String kalimat) {
      final words =
          kalimat.split(' ').where((word) => word.isNotEmpty).toList();

      if (words.length <= 2) {
        // Kembalikan kalimat asli dengan kapitalisasi awal tiap kata
        return words.map((w) => w[0].toUpperCase() + w.substring(1)).join(' ');
      }

      // Jika lebih dari 2 kata, ambil huruf awal tiap kata
      return words.map((word) => word[0].toUpperCase()).join();
    }

    return MasonryGridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: notes.length,
      gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
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
              border: Border.all(color: theme.dividerColor, width: 1.2),
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
                    ),
                  if (note.matkul != null || note.desc != "")
                    Chip(
                      label: Text(getInitials(note.matkul!)),
                      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 3),
                    )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
