import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaku/controllers/main_tab_controller.dart';
import 'package:jaku/controllers/matkul_controller.dart';
import 'package:jaku/modules/task/controller/task_controller.dart';
import 'package:jaku/data/models/task.dart';
import 'package:jaku/modules/task/widgets/edit_group_modal.dart';
import 'package:jaku/modules/task/widgets/task_tile.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:reorderables/reorderables.dart';

class BuildTaskWidget extends StatefulWidget {
  const BuildTaskWidget({
    super.key,
    required this.group,
    this.groupId,
    this.deleteTabFunction,
  });

  final String group;
  final String? groupId;
  final void Function(String groupId)? deleteTabFunction;

  @override
  State<BuildTaskWidget> createState() => _BuildTaskWidgetState();
}

class _BuildTaskWidgetState extends State<BuildTaskWidget> {
  final taskC = Get.find<TaskController>();
  final tabC = Get.find<MainTabController>();
  final matkulC = Get.find<MatkulController>();

  bool showCompleted = false;

  void deleteTab() {
    Get.defaultDialog(
      title: "Hapus task?",
      titleStyle: const TextStyle(fontWeight: FontWeight.bold),
      backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
      content: Text(
        "Yakin ingin menghapus task ${taskC.titleC.text}?",
        textAlign: TextAlign.center,
      ),
      cancel: FilledButton(
        onPressed: () {
          Get.back();
        },
        child: const Text("Tidak"),
      ),
      confirm: OutlinedButton(
        onPressed: () {
          try {
            Get.back();
            widget.deleteTabFunction!(widget.groupId!);
            Get.back();
          } catch (error) {
            print(error);
          }
        },
        child: const Text("Ya"),
      ),
    );
  }

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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.group, style: theme.textTheme.bodyLarge),
                      if (widget.groupId!.startsWith("tab"))
                        DropdownButton2(
                          customButton: const Icon(
                            LucideIcons.ellipsisVertical,
                          ),
                          buttonStyleData: ButtonStyleData(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),

                          items: const [
                            DropdownMenuItem<Object>(
                              value: 0,
                              child: Row(
                                spacing: 6,
                                children: [
                                  Icon(LucideIcons.pencilLine),
                                  Text("Edit tab"),
                                ],
                              ),
                            ),
                            DropdownMenuItem<Object>(
                              value: 1,
                              child: Row(
                                spacing: 6,
                                children: [
                                  Icon(LucideIcons.trash2),
                                  Text("Delete tab"),
                                ],
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            if (value == 0) {
                              showBarModalBottomSheet<Map<String, dynamic>>(
                                barrierColor: Colors.black.withValues(
                                  alpha: 0.4,
                                ),
                                context: context,
                                useRootNavigator: true,
                                bounce: true,
                                backgroundColor:
                                    theme.colorScheme.surfaceContainer,
                                builder: (context) =>
                                    EditGroupModal(groupId: widget.groupId!),
                              );
                            } else if (value == 1) {
                              deleteTab();
                            }
                          },
                          alignment: AlignmentDirectional.bottomStart,
                          dropdownStyleData: DropdownStyleData(
                            width: 150,
                            maxHeight: 200,
                            direction: DropdownDirection.textDirection,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                incompleteTasks.isEmpty
                    ? completedTasks.isEmpty
                          ? Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                children: [
                                  Text(
                                    "Tidak ada task",
                                    style: theme.textTheme.bodyLarge,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.all(12),
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
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                children: [
                                  Text(
                                    "semua task sudah selesai",
                                    style: theme.textTheme.bodyLarge,
                                  ),
                                  Container(
                                    height: 230,
                                    margin: const EdgeInsets.all(12),
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
              ? const SizedBox.shrink()
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
