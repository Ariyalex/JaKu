import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaku/controllers/task_controllers/task_controller.dart';
import 'package:jaku/widgets/task_widgets/detail_task_modal.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({super.key, required this.taskId, this.star = true});
  final String taskId;
  final bool star;

  @override
  Widget build(BuildContext context) {
    final taskC = Get.find<TaskController>();

    return Obx(() {
      final task = taskC.selectById(taskId);
      if (task == null) return SizedBox.shrink();

      return ListTile(
        key: ValueKey(task.id),
        onTap: () {
          showBarModalBottomSheet<Map<String, dynamic>>(
            barrierColor: Colors.black.withValues(alpha: 0.4),
            context: context,
            useRootNavigator: true,
            bounce: true,
            backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
            builder: (context) => DetailTaskModal(taskId: task.id),
          );
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

        contentPadding: EdgeInsets.zero,
        leading: Checkbox(
          value: task.status,
          onChanged: (val) {
            taskC.updateTaskStatus(task.id, val ?? false);
          },
        ),
        title: Text(
          task.task,
          style: task.status
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
                            task.taskDueDate?.hour ?? 0,
                            task.taskDueDate?.minute ?? 0,
                          ),
                          format: task.taskDueDate?.hour == null
                              ? "d F Y"
                              : "d F Y, H:i",
                        ),
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                    ),
                ],
              )
            : null,
        trailing: star
            ? IconButton(
                onPressed: () {
                  taskC.updateTaskStarred(task.id, !task.isStared);
                },
                icon: task.isStared
                    ? const Icon(Icons.star, color: Colors.amber)
                    : const Icon(Icons.star_border),
              )
            : null,
      );
    });
  }
}
