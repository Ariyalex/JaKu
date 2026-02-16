import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:jaku/controllers/matkul_controller.dart';
import 'package:jaku/data/models/note.dart';
import 'package:jaku/core/routes/route_named.dart';

class NoteGlobal extends StatelessWidget {
  const NoteGlobal({super.key, this.showMatkul = true, required this.notes});

  final bool showMatkul;
  final List<Note> notes;

  @override
  Widget build(BuildContext context) {
    final matkulC = Get.find<MatkulController>();
    final theme = Theme.of(context);

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
        final Note note = notes[index];
        String? matkulNote;
        if (note.matkulId != null && note.matkulId != "") {
          matkulNote = matkulC
              .selectMatkulById(note.matkulId!)!
              .nameAbbreviation;
        }
        print(note.matkul);
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
                    if (matkulNote != null && matkulNote.isNotEmpty)
                      Chip(
                        label: Text(matkulNote),
                        padding: const EdgeInsets.symmetric(
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
    );
  }
}
