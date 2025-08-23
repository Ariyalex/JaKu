import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaku/controllers/task_controllers/task_controller.dart';
import 'package:jaku/models/task.dart';
import 'package:jaku/widgets/task_widgets/task_tile.dart';
import 'package:reorderables/reorderables.dart';

class BuildTaskWidget extends StatefulWidget {
  const BuildTaskWidget({super.key, required this.group, this.groupId});

  final String group;
  final String? groupId;

  @override
  State<BuildTaskWidget> createState() => _BuildTaskWidgetState();
}

class _BuildTaskWidgetState extends State<BuildTaskWidget> {
  final taskC = Get.find<TaskController>();

  bool showCompleted = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      late List<Task> groupTasks;

      if (widget.groupId == "0") {
        groupTasks = taskC.allTask.where((t) => t.isStared).toList();
        groupTasks.sort(
          (a, b) => (a.starredOrder ?? 0).compareTo(b.starredOrder ?? 0),
        );
      } else if (widget.groupId == "1") {
        groupTasks = taskC.allTask
            .where((t) => t.groupId == null || t.groupId == "")
            .toList();
        groupTasks.sort(
          (a, b) => (a.matkulOrder ?? 0).compareTo(b.matkulOrder ?? 0),
        );
      } else {
        groupTasks = taskC.allTask
            .where((t) => t.groupId == widget.groupId)
            .toList();
        //urutkan berda
        groupTasks.sort(
          (a, b) => (a.matkulOrder ?? 0).compareTo(b.matkulOrder ?? 0),
        );
      }

      final completedTasks = groupTasks.where((task) => task.status).toList();
      final incompleteTasks = groupTasks.where((task) => !task.status).toList();

      // Pisahkan task berdasarkan status

      void onReorderCompleted(int oldIndex, int newIndex) {
        taskC.reorderTasks(completedTasks, oldIndex, newIndex, widget.groupId);
      }

      void onReorderIncompleted(int oldIndex, int newIndex) {
        taskC.reorderTasks(incompleteTasks, oldIndex, newIndex, widget.groupId);
      }

      return ListView(
        padding: const EdgeInsets.only(bottom: 65, top: 8, left: 12, right: 12),
        children: [
          // Card untuk setiap matkul (incomplete)
          Card(
            color: theme.colorScheme.surfaceContainer,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 20,
                  ),
                  child: Row(
                    children: [
                      Text(widget.group, style: theme.textTheme.bodyLarge),
                    ],
                  ),
                ),
                incompleteTasks.isEmpty
                    ? completedTasks.isEmpty
                          ? Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(12),
                              child: Column(
                                children: [
                                  Text(
                                    "Tidak ada task",
                                    style: theme.textTheme.bodyLarge,
                                  ),
                                  Container(
                                    margin: EdgeInsets.all(12),
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Image.asset("images/malas.gif"),
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(12),
                              child: Column(
                                children: [
                                  Text(
                                    "semua task sudah selesai",
                                    style: theme.textTheme.bodyLarge,
                                  ),
                                  Container(
                                    height: 230,
                                    margin: EdgeInsets.all(12),
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Image.asset("images/cihuyy.jpeg"),
                                  ),
                                ],
                              ),
                            )
                    : ReorderableColumn(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 20,
                        ),
                        crossAxisAlignment: CrossAxisAlignment.center,
                        onReorder: onReorderIncompleted,
                        buildDraggableFeedback: (context, constraints, child) {
                          return SizedBox(
                            width: constraints.maxWidth,
                            height: constraints.maxHeight,
                            child: Material(
                              elevation: 1,
                              borderRadius: BorderRadius.circular(16),
                              child: child,
                            ),
                          );
                        },
                        children: incompleteTasks
                            .map(
                              (task) => TaskTile(
                                taskId: task.id,
                                key: widget.groupId == "0"
                                    ? ValueKey(task.starredOrder)
                                    : ValueKey(task.matkulOrder),
                              ),
                            )
                            .toList(),
                      ),
              ],
            ),
          ),

          // Card untuk completed
          completedTasks.isEmpty
              ? SizedBox.shrink()
              : Card(
                  color: theme.colorScheme.surfaceContainer,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () =>
                            setState(() => showCompleted = !showCompleted),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 20,
                          ),
                          child: Row(
                            children: [
                              const Text(
                                "Completed",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                showCompleted
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                              ),
                              const Spacer(),
                              Text("(${completedTasks.length})"),
                            ],
                          ),
                        ),
                      ),
                      if (showCompleted)
                        ReorderableColumn(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 20,
                          ),
                          onReorder: onReorderCompleted,
                          buildDraggableFeedback:
                              (context, constraints, child) {
                                return Material(
                                  elevation: 1,
                                  borderRadius: BorderRadius.circular(16),
                                  child: SizedBox(
                                    width: constraints.maxWidth,
                                    height: constraints.maxHeight,
                                    child: child,
                                  ),
                                );
                              },
                          children: completedTasks
                              .map(
                                (task) => TaskTile(
                                  taskId: task.id,
                                  key: widget.groupId == "0"
                                      ? ValueKey(task.starredOrder)
                                      : ValueKey(task.matkulOrder),
                                ),
                              )
                              .toList(),
                        ),
                    ],
                  ),
                ),
        ],
      );
    });
  }
}
