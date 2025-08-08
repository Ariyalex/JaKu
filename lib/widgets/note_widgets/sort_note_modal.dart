import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class SortNoteModal extends StatelessWidget {
  const SortNoteModal({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  'Sorting',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ListTile(
                  onTap: () {},
                  leading: Icon(LucideIcons.check),
                  selected: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  selectedTileColor: theme.focusColor,
                  title: Text('Sort by Created Date'),
                ),
              ),
              ListTile(
                onTap: () {},
                title: Text('Sort by Modified Date'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
