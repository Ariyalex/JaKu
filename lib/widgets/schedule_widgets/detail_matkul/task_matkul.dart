import 'package:flutter/material.dart';
import 'package:jaku/models/task.dart';
import 'package:jaku/screens/schedule/detail_matkul.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class TaskMatkul extends StatelessWidget {
  const TaskMatkul({
    super.key,
    required this.theme,
    required this.tasks,
  });

  final ThemeData theme;
  final List<Task> tasks;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Tugas",
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(LucideIcons.plus),
              tooltip: "Tambah Tugas",
              onPressed: () {
                // TODO: Tambah task
              },
            ),
          ],
        ),
        tasks.isEmpty
            ? Text("Belum ada tugas.", style: theme.textTheme.bodyMedium)
            : Column(
                children: tasks
                    .map((task) => Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: theme.dividerColor, width: 1.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: CheckboxListTile(
                            value: task.status,
                            onChanged: (val) {
                              // TODO: Update status task
                            },
                            title: Text(task.task),
                            subtitle: task.dateTime != null
                                ? Text(formatTaskDate(
                                    task.dateTime ?? DateTime.now()))
                                : null,
                          ),
                        ))
                    .toList(),
              ),
      ],
    );
  }
}
