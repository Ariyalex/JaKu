import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:jaku/controllers/note_controllers/note_controllers.dart';
import 'package:jaku/models/note.dart';
import 'package:jaku/routes/route_named.dart';

String getInitials(String kalimat) {
  final words = kalimat
      .split(' ')
      .where((word) => word.isNotEmpty && word.toLowerCase() != 'dan')
      .toList();

  if (words.length <= 2) {
    // Kembalikan kalimat asli dengan kapitalisasi awal tiap kata
    return words.map((w) => w[0].toUpperCase() + w.substring(1)).join(' ');
  }

  // Jika lebih dari 2 kata, ambil huruf awal tiap kata
  return words.map((word) => word[0].toUpperCase()).join();
}

class NoteGlobal extends StatelessWidget {
  const NoteGlobal({super.key, this.showMatkul = true});

  final bool showMatkul;

  @override
  Widget build(BuildContext context) {
    final noteC = Get.find<NoteControllers>();
    final notes = noteC.allNote;
    final theme = Theme.of(context);

    return Obx(
      () => MasonryGridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: notes.length,
        gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        itemBuilder: (context, index) {
          final Note note = notes[index];
          return InkWell(
            onTap: () {
              Get.toNamed(RouteNamed.detailNote, arguments: note.id);
            },
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
                    if (note.title != null && note.title!.isNotEmpty)
                      Text(
                        note.title!,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    const SizedBox(height: 6),
                    if (note.desc != null && note.desc!.isNotEmpty)
                      Text(note.desc!, style: theme.textTheme.bodySmall),
                    if (showMatkul)
                      if (note.matkul != null && note.matkul!.isNotEmpty)
                        Chip(
                          label: Text(getInitials(note.matkul!)),
                          padding: EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: 3,
                          ),
                        ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
