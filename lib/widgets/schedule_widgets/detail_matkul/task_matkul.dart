import 'package:flutter/material.dart';
import 'package:jaku/models/task.dart';
import 'package:jaku/widgets/note_widgets/note_global.dart';
import 'package:jaku/widgets/task_widgets/add_task_modal.dart';
import 'package:jaku/widgets/task_widgets/task_tile.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class TaskMatkul extends StatelessWidget {
  const TaskMatkul({
    super.key,
    required this.theme,
    required this.tasks,
    this.matkul,
  });

  final ThemeData theme;
  final List<Task> tasks;
  final String? matkul;

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
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(LucideIcons.plus),
              tooltip: "Tambah Tugas",
              onPressed: () {
                // TODO: Tambah task
                showBarModalBottomSheet<Map<String, dynamic>>(
                  barrierColor: Colors.black.withValues(alpha: 0.4),
                  context: context,
                  useRootNavigator: true,
                  bounce: true,
                  backgroundColor: theme.colorScheme.surfaceContainer,
                  builder: (context) =>
                      AddTaskModal(matkul: getInitials(matkul!)),
                );
              },
            ),
          ],
        ),
        tasks.isEmpty
            ? Text("Belum ada tugas.", style: theme.textTheme.bodyMedium)
            : Column(
                children: tasks
                    .map(
                      (task) => Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: theme.dividerColor,
                            width: 1.2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: TaskTile(
                          task: task,
                          completed: task.status,
                          star: false,
                        ),
                      ),
                    )
                    .toList(),
              ),
      ],
    );
  }
}
