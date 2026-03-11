import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jaku/data/entities/task.dart';
import 'package:jaku/modules/main_tab/bloc/main_tab_bloc.dart';
import 'package:jaku/modules/matkul/bloc/matkul_bloc.dart';
import 'package:jaku/modules/task/bloc/task_bloc.dart';
import 'package:jaku/modules/task/bloc/task_event.dart';
import 'package:jaku/modules/task/widgets/detail_task_modal.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:timeago/timeago.dart' as timeago;

class TaskTile extends HookWidget {
  const TaskTile({
    super.key,
    required this.task,
    this.star = true,
    this.showGroup = false,
  });
  final Task task;
  final bool star;
  final bool showGroup;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    String? groupName;

    useEffect(() {
      if (showGroup == true) {
        int matkulIndex = context.read<MatkulBloc>().state.matkuls.indexWhere(
          (element) => element.id == task.groupId,
        );
        if (matkulIndex == -1) {
          int taskTabIndex = context
              .read<MainTabBloc>()
              .state
              .taskTabs
              .indexWhere((element) => element.id == task.groupId);
          if (taskTabIndex != -1) {
            groupName = context
                .read<MainTabBloc>()
                .state
                .taskTabs[taskTabIndex]
                .tabName;
          }
        } else {
          groupName = context
              .read<MatkulBloc>()
              .state
              .matkuls[matkulIndex]
              .nameAbbreviation;
        }
      }
      return null;
    }, [showGroup]);

    bool isToday(DateTime date) {
      final now = DateTime.now();
      return date.year == now.year &&
          date.month == now.month &&
          date.day == now.day;
    }

    bool isTomorrow(DateTime date) {
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      return date.year == tomorrow.year &&
          date.month == tomorrow.month &&
          date.day == tomorrow.day;
    }

    Widget showTime(DateTime dateTime) {
      if (dateTime.isBefore(DateTime.now())) {
        return Text(
          timeago.format(dateTime),
          style: TextStyle(
            color: Colors.redAccent.shade200,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        );
      } else if (isTomorrow(dateTime)) {
        return Text(
          "Tomorrow, ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}",
          style: TextStyle(color: Colors.grey.shade800, fontSize: 14),
        );
      } else if (isToday(dateTime)) {
        return Text(
          "Today, ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}",
          style: TextStyle(
            color: theme.colorScheme.secondary,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        );
      } else {
        return Text(
          DateTimeFormat.format(
            DateTime(
              task.taskDueDate!.year,
              task.taskDueDate!.month,
              task.taskDueDate!.day,
              task.taskDueDate?.hour ?? 0,
              task.taskDueDate?.minute ?? 0,
            ),
            format:
                task.taskDueDate?.hour == null ||
                    (task.taskDueDate?.hour == 0 &&
                        task.taskDueDate?.minute == 0)
                ? "d F Y"
                : "d F Y, H:i",
          ),
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        );
      }
    }

    return ListTile(
      onTap: () {
        showBarModalBottomSheet<void>(
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
          context.read<TaskBloc>().add(UpdateTaskStatus(task.id, val ?? false));
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
                    child: showTime(task.taskDueDate!),
                  ),

                if (groupName != null)
                  Chip(
                    label: Text(groupName!),
                    padding: const EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 3,
                    ),
                  ),
              ],
            )
          : null,
      trailing: star
          ? IconButton(
              onPressed: () {
                context.read<TaskBloc>().add(
                  UpdateTaskStarred(task.id, !task.isStared),
                );
              },
              icon: task.isStared
                  ? const Icon(Icons.star, color: Colors.amber)
                  : const Icon(Icons.star_border),
            )
          : null,
    );
  }
}
