import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class NoteMatkul extends StatelessWidget {
  const NoteMatkul({
    super.key,
    required this.theme,
    required this.notes,
  });

  final ThemeData theme;
  final List<Map<String, String>> notes;

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
            : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: notes.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1.2, // Atur sesuai kebutuhan
                ),
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: theme.dividerColor, width: 1.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            note["title"] ?? "",
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Expanded(
                            child: Text(
                              note["desc"] ?? "",
                              style: theme.textTheme.bodyMedium,
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ],
    );
  }
}
