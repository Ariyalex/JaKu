import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:jaku/modules/task/bloc/task_bloc.dart';
import 'package:jaku/modules/task/bloc/task_event.dart';
import 'package:jaku/modules/task/bloc/task_state.dart';
import 'package:jaku/data/entities/task.dart';
import 'package:jaku/modules/task/widgets/edit_group_modal.dart';
import 'package:jaku/modules/task/widgets/task_tile.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:reorderables/reorderables.dart';

class BuildTaskWidget extends HookWidget {
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final showCompleted = useState<bool>(false);

    void deleteTabDialog() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Hapus tab?", style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: theme.dialogTheme.backgroundColor,
          content: Text("Yakin ingin menghapus tab $group?", textAlign: TextAlign.center),
          actions: [
            FilledButton(onPressed: () => context.pop(), child: const Text("Tidak")),
            OutlinedButton(
              onPressed: () {
                context.pop();
                if (deleteTabFunction != null && groupId != null) {
                  deleteTabFunction!(groupId!);
                }
              },
              child: const Text("Ya"),
            ),
          ],
        ),
      );
    }

    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        if (state.status == TaskStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == TaskStatus.success) {
          late List<Task> groupTasks;
          if (groupId == "0") {
            groupTasks = state.tasks.where((t) => t.isStared).toList();
            groupTasks.sort((a, b) => (a.starredOrder ?? 0).compareTo(b.starredOrder ?? 0));
          } else if (groupId == "1") {
            groupTasks = state.tasks.where((t) => t.groupId == null || t.groupId == "").toList();
            groupTasks.sort((a, b) => (a.matkulOrder ?? 0).compareTo(b.matkulOrder ?? 0));
          } else {
            groupTasks = state.tasks.where((t) => t.groupId == groupId).toList();
            groupTasks.sort((a, b) => (a.matkulOrder ?? 0).compareTo(b.matkulOrder ?? 0));
          }

          final completedTasks = groupTasks.where((task) => task.status).toList();
          final incompleteTasks = groupTasks.where((task) => !task.status).toList();

          void onReorder(List<Task> tasks, int oldIndex, int newIndex) {
            final reorderedList = List<Task>.from(tasks);
            final item = reorderedList.removeAt(oldIndex);
            reorderedList.insert(newIndex, item);
            context.read<TaskBloc>().add(ReorderTasks(reorderedList, groupId));
          }

          return ListView(
            padding: const EdgeInsets.only(bottom: 65, top: 8, left: 12, right: 12),
            children: [
              Card(
                color: theme.colorScheme.surfaceContainer,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(group, style: theme.textTheme.bodyLarge),
                          if (groupId != null && groupId!.startsWith("tab"))
                            DropdownButton2<int>(
                              customButton: const Icon(LucideIcons.ellipsisVertical),
                              items: const [
                                DropdownItem(value: 0, child: Row(spacing: 6, children: [Icon(LucideIcons.pencilLine), Text("Edit tab")])),
                                DropdownItem(value: 1, child: Row(spacing: 6, children: [Icon(LucideIcons.trash2), Text("Delete tab")])),
                              ],
                              onChanged: (value) {
                                if (value == 0) {
                                  showBarModalBottomSheet<void>(
                                    barrierColor: Colors.black.withValues(alpha: 0.4),
                                    context: context,
                                    useRootNavigator: true,
                                    bounce: true,
                                    backgroundColor: theme.colorScheme.surfaceContainer,
                                    builder: (context) => EditGroupModal(groupId: groupId!),
                                  );
                                } else if (value == 1) {
                                  deleteTabDialog();
                                }
                              },
                              dropdownStyleData: DropdownStyleData(
                                width: 150,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (incompleteTasks.isEmpty && completedTasks.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            Text("Tidak ada task", style: theme.textTheme.bodyLarge),
                            Container(
                              margin: const EdgeInsets.all(12),
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
                              child: Image.asset("images/malas.gif"),
                            ),
                          ],
                        ),
                      )
                    else if (incompleteTasks.isEmpty && completedTasks.isNotEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            Text("semua task sudah selesai", style: theme.textTheme.bodyLarge),
                            Container(
                              height: 230,
                              margin: const EdgeInsets.all(12),
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
                              child: Image.asset("images/cihuyy.jpeg"),
                            ),
                          ],
                        ),
                      )
                    else
                      ReorderableColumn(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                        onReorder: (oldIndex, newIndex) => onReorder(incompleteTasks, oldIndex, newIndex),
                        children: incompleteTasks.map((task) => TaskTile(
                          taskId: task.id,
                          key: ValueKey(task.id),
                        )).toList(),
                      ),
                  ],
                ),
              ),
              if (completedTasks.isNotEmpty)
                Card(
                  color: theme.colorScheme.surfaceContainer,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () => showCompleted.value = !showCompleted.value,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                          child: Row(
                            children: [
                              const Text("Completed", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              const SizedBox(width: 8),
                              Icon(showCompleted.value ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
                              const Spacer(),
                              Text("(${completedTasks.length})"),
                            ],
                          ),
                        ),
                      ),
                      if (showCompleted.value)
                        ReorderableColumn(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                          onReorder: (oldIndex, newIndex) => onReorder(completedTasks, oldIndex, newIndex),
                          children: completedTasks.map((task) => TaskTile(
                            taskId: task.id,
                            key: ValueKey(task.id),
                          )).toList(),
                        ),
                    ],
                  ),
                ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
