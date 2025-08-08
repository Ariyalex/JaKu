import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:jaku/models/task.dart';
import 'package:jaku/widgets/task_widgets/detail_task_modal.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class TaskTile extends StatefulWidget {
  const TaskTile({
    super.key,
    required this.task,
    required this.completed,
    this.star = true,
  });
  final Task task;
  final bool completed;
  final bool star;

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  @override
  Widget build(BuildContext context) {
    final task = widget.task;
    final completed = widget.completed;

    return ListTile(
      key: ValueKey(task.id),
      onTap: () {
        showBarModalBottomSheet<Map<String, dynamic>>(
          barrierColor: Colors.black.withValues(alpha: 0.4),
          context: context,
          useRootNavigator: true,
          bounce: true,
          backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
          builder: (context) => DetailTaskModal(task: task),
        );
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

      contentPadding: EdgeInsets.zero,
      leading: Checkbox(
        value: task.status,
        onChanged: (val) {
          // TODO: update status
        },
      ),
      title: Text(
        task.task,
        style: completed
            ? const TextStyle(
                decoration: TextDecoration.lineThrough,
                color: Colors.grey,
              )
            : null,
      ),
      subtitle:
          (task.desc != null && task.desc!.isNotEmpty) ||
              task.taskDueDate != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (task.desc != null && task.desc!.isNotEmpty)
                  Text(
                    task.desc!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                if (task.taskDueDate != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text(
                      DateTimeFormat.format(
                        DateTime(
                          task.taskDueDate!.year,
                          task.taskDueDate!.month,
                          task.taskDueDate!.day,
                          task.taskDueTime?.hour ?? 0,
                          task.taskDueTime?.minute ?? 0,
                        ),
                        format: task.taskDueTime == null
                            ? "d F Y"
                            : "d F Y, H:i",
                      ),
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                  ),
              ],
            )
          : null,
      trailing: widget.star
          ? IconButton(
              onPressed: () {
                setState(() {
                  task.isStared = !task.isStared;
                });
              },
              icon: task.isStared
                  ? const Icon(Icons.star, color: Colors.amber)
                  : const Icon(Icons.star_border),
            )
          : null,
    );
  }
}
