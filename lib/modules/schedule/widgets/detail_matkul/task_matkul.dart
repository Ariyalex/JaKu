import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jaku/data/entities/task.dart';
import 'package:jaku/modules/task/bloc/task_bloc.dart';
import 'package:jaku/modules/task/bloc/task_event.dart';
import 'package:jaku/modules/task/bloc/task_state.dart';
import 'package:jaku/modules/task/widgets/add_task_modal.dart';
import 'package:jaku/modules/task/widgets/task_tile.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class TaskMatkul extends HookWidget {
  const TaskMatkul({super.key, required this.matkulId});

  final String matkulId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final taskBloc = context.read<TaskBloc>();

    useEffect(() {
      taskBloc.add(LoadListTaskByMatkul(matkulId));
      return;
    }, [matkulId]);

    return BlocBuilder<TaskBloc, TaskState>(
      bloc: taskBloc,
      builder: (context, state) {
        if (state.status == TaskStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == TaskStatus.success) {
          final List<Task> tasks = state.filteredTasks;

          tasks.sort(
            (a, b) => (a.groupOrder ?? 0).compareTo(b.groupOrder ?? 0),
          );

          void onReorder(List<Task> tasks, int oldIndex, int newIndex) {
            final reorderedList = List<Task>.from(tasks);

            if (oldIndex < newIndex) {
              newIndex -= 1;
            }

            final item = reorderedList.removeAt(oldIndex);
            reorderedList.insert(newIndex, item);

            taskBloc.add(ReorderTasks(reorderedList, null));
            taskBloc.add(LoadListTaskByMatkul(matkulId));
          }

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
                    onPressed: () async {
                      await showBarModalBottomSheet<void>(
                        barrierColor: Colors.black.withValues(alpha: 0.4),
                        context: context,
                        useRootNavigator: true,
                        bounce: true,
                        backgroundColor: theme.colorScheme.surfaceContainer,
                        builder: (context) => AddTaskModal(matkulId: matkulId),
                      );

                      taskBloc.add(LoadListTaskByMatkul(matkulId));
                    },
                  ),
                ],
              ),
              tasks.isEmpty
                  ? Text("Belum ada tugas.", style: theme.textTheme.bodyMedium)
                  : ReorderableListView(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 20,
                      ),
                      onReorder: (oldIndex, newIndex) =>
                          onReorder(tasks, oldIndex, newIndex),
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
                      children: tasks
                          .map(
                            (task) => TaskTile(
                              key: ValueKey(task.id),
                              task: task,
                              star: false,
                              showGroup: false,
                              matkulId: matkulId,
                            ),
                          )
                          .toList(),
                    ),
            ],
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}
