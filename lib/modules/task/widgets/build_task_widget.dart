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

class BuildTaskWidget extends HookWidget {
  const BuildTaskWidget({
    super.key,
    required this.tabName,
    this.tabIndex,
    this.deleteTabFunction,
  });

  final String tabName;
  final String? tabIndex;
  final void Function(String groupId)? deleteTabFunction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final showCompleted = useState<bool>(false);

    void deleteTabDialog() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            "Hapus tab?",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: theme.dialogTheme.backgroundColor,
          content: Text(
            "Yakin ingin menghapus tab $tabName?",
            textAlign: TextAlign.center,
          ),
          actions: [
            FilledButton(
              onPressed: () => context.pop(),
              child: const Text("Tidak"),
            ),
            OutlinedButton(
              onPressed: () {
                context.pop();
                if (deleteTabFunction != null && tabIndex != null) {
                  deleteTabFunction!(tabIndex!);
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
          List<Task> groupTasks = List<Task>.from(state.tasks);

          // 2. Tentukan logika filter dan sorting berdasarkan tabIndex
          switch (tabIndex) {
            case "0": // All Tasks
              groupTasks.sort(
                (a, b) => (a.allOrder ?? 0).compareTo(b.allOrder ?? 0),
              );
              break;

            case "1": // Starred Tasks
              groupTasks = groupTasks.where((t) => t.isStared).toList();
              groupTasks.sort(
                (a, b) => (a.starredOrder ?? 0).compareTo(b.starredOrder ?? 0),
              );
              break;

            case "2": // Uncategorized (No Group)
              groupTasks = groupTasks
                  .where((t) => t.groupId == null || t.groupId == "")
                  .toList();
              groupTasks.sort(
                (a, b) => (a.groupOrder ?? 0).compareTo(b.groupOrder ?? 0),
              );
              break;

            default: // Specific Group/Tab
              groupTasks = groupTasks
                  .where((t) => t.groupId == tabIndex)
                  .toList();
              groupTasks.sort(
                (a, b) => (a.groupOrder ?? 0).compareTo(b.groupOrder ?? 0),
              );
          }

          final completedTasks = groupTasks
              .where((task) => task.status)
              .toList();
          final incompleteTasks = groupTasks
              .where((task) => !task.status)
              .toList();

          void onReorder(List<Task> tasks, int oldIndex, int newIndex) {
            final reorderedList = List<Task>.from(tasks);

            if (oldIndex < newIndex) {
              newIndex -= 1;
            }

            final item = reorderedList.removeAt(oldIndex);
            reorderedList.insert(newIndex, item);

            context.read<TaskBloc>().add(ReorderTasks(reorderedList, tabIndex));
          }

          return ListView(
            padding: const EdgeInsets.only(
              bottom: 65,
              top: 8,
              left: 12,
              right: 12,
            ),
            children: [
              Card(
                color: theme.colorScheme.surfaceContainer,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(tabName, style: theme.textTheme.bodyLarge),
                          if (tabIndex != null && tabIndex!.startsWith("tab"))
                            DropdownButtonHideUnderline(
                              child: DropdownButton2<int>(
                                customButton: const Icon(
                                  LucideIcons.ellipsisVertical,
                                ),
                                items: const [
                                  DropdownItem(
                                    value: 0,
                                    child: Row(
                                      spacing: 6,
                                      children: [
                                        Icon(LucideIcons.pencilLine),
                                        Text("Edit tab"),
                                      ],
                                    ),
                                  ),
                                  DropdownItem(
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
                                    showBarModalBottomSheet<void>(
                                      barrierColor: Colors.black.withValues(
                                        alpha: 0.4,
                                      ),
                                      context: context,
                                      useRootNavigator: true,
                                      bounce: true,
                                      backgroundColor:
                                          theme.colorScheme.surfaceContainer,
                                      builder: (context) =>
                                          EditGroupModal(groupId: tabIndex!),
                                    );
                                  } else if (value == 1) {
                                    deleteTabDialog();
                                  }
                                },
                                dropdownStyleData: DropdownStyleData(
                                  width: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
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
                    else if (incompleteTasks.isEmpty &&
                        completedTasks.isNotEmpty)
                      Container(
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
                    else
                      ReorderableListView(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 20,
                        ),
                        proxyDecorator:
                            (
                              Widget child,
                              int index,
                              Animation<double> animation,
                            ) {
                              return AnimatedBuilder(
                                animation: animation,
                                builder: (BuildContext context, Widget? child) {
                                  return Material(
                                    elevation: 4,
                                    // WAJIB: Tambahkan borderRadius di sini agar tidak lancip 🛠️
                                    borderRadius: BorderRadius.circular(12),
                                    // Pindahkan warna background ke sini
                                    color: theme.colorScheme.surfaceContainer,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: theme.colorScheme.secondary,
                                          width: 2.0,
                                        ),
                                      ),
                                      child: child,
                                    ),
                                  );
                                },
                                child: child,
                              );
                            },
                        onReorder: (oldIndex, newIndex) =>
                            onReorder(incompleteTasks, oldIndex, newIndex),
                        children: incompleteTasks
                            .map(
                              (task) => TaskTile(
                                task: task,
                                key: ValueKey(task.id),
                                showGroup: tabIndex == "0" || tabIndex == "1"
                                    ? true
                                    : false,
                              ),
                            )
                            .toList(),
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
                                showCompleted.value
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                              ),
                              const Spacer(),
                              Text("(${completedTasks.length})"),
                            ],
                          ),
                        ),
                      ),
                      if (showCompleted.value)
                        ReorderableListView(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 20,
                          ),
                          onReorder: (oldIndex, newIndex) =>
                              onReorder(completedTasks, oldIndex, newIndex),
                          proxyDecorator:
                              (
                                Widget child,
                                int index,
                                Animation<double> animation,
                              ) {
                                return AnimatedBuilder(
                                  animation: animation,
                                  builder: (BuildContext context, Widget? child) {
                                    return Material(
                                      elevation: 4,
                                      // WAJIB: Tambahkan borderRadius di sini agar tidak lancip 🛠️
                                      borderRadius: BorderRadius.circular(12),
                                      // Pindahkan warna background ke sini
                                      color: theme.colorScheme.surfaceContainer,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: theme.colorScheme.secondary,
                                            width: 2.0,
                                          ),
                                        ),
                                        child: child,
                                      ),
                                    );
                                  },
                                  child: child,
                                );
                              },
                          children: completedTasks
                              .map(
                                (task) => TaskTile(
                                  task: task,
                                  key: ValueKey(task.id),
                                  showGroup: tabIndex == "0" ? true : false,
                                ),
                              )
                              .toList(),
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
