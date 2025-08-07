import 'package:flutter/material.dart';
import 'package:jaku/models/task.dart';
import 'package:jaku/widgets/task_widgets/task_tile.dart';
import 'package:reorderables/reorderables.dart';

class BuildTaskWidget extends StatefulWidget {
  const BuildTaskWidget({
    super.key,
    required this.filteredTasks,
    required this.title,
  });

  final List<Task> filteredTasks;
  final String title;

  @override
  State<BuildTaskWidget> createState() => _BuildTaskWidgetState();
}

class _BuildTaskWidgetState extends State<BuildTaskWidget> {
  bool showCompleted = false;
  late List<Task> completedTasks;
  late List<Task> incompleteTasks;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    completedTasks = widget.filteredTasks.where((task) => task.status).toList();
    incompleteTasks = widget.filteredTasks
        .where((task) => !task.status)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Pisahkan task berdasarkan status

    void onReorderCompleted(int oldIndex, int newIndex) {
      setState(() {
        final task = completedTasks.removeAt(oldIndex);
        completedTasks.insert(newIndex, task);
      });
    }

    void onReorderIncompleted(int oldIndex, int newIndex) {
      setState(() {
        final task = incompleteTasks.removeAt(oldIndex);
        incompleteTasks.insert(newIndex, task);
      });
    }

    // Kelompokkan incomplete task per matkul
    final Map<String, List<Task>> matkulGroups = {};
    for (var task in incompleteTasks) {
      final matkul = (task.matkul?.isNotEmpty == true) ? task.matkul! : "Umum";
      matkulGroups.putIfAbsent(matkul, () => []).add(task);
    }

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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
                    Text(widget.title, style: theme.textTheme.bodyLarge),
                  ],
                ),
              ),
              incompleteTasks.isEmpty
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
                  : ReorderableColumn(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 20,
                      ),
                      crossAxisAlignment: CrossAxisAlignment.center,
                      onReorder: onReorderIncompleted,
                      children: incompleteTasks
                          .map(
                            (task) => TaskTile(
                              task: task,
                              completed: false,
                              key: ValueKey(task.id),
                            ),
                          )
                          .toList(),
                    ),
            ],
          ),
        ),

        // Card untuk completed
        Card(
          color: theme.colorScheme.surfaceContainer,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () => setState(() => showCompleted = !showCompleted),
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
                  children: completedTasks
                      .map(
                        (task) => TaskTile(
                          task: task,
                          completed: true,
                          key: ValueKey(task.id),
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
}
