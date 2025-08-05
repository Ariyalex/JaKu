import 'package:flutter/material.dart';
import 'package:jaku/models/task.dart';
import 'package:jaku/screens/schedule/detail_matkul.dart';

class BuildTaskWidget extends StatefulWidget {
  const BuildTaskWidget(
      {super.key, required this.filteredTasks, required this.title});

  final List<Task> filteredTasks;
  final String title;

  @override
  State<BuildTaskWidget> createState() => _BuildTaskWidgetState();
}

class _BuildTaskWidgetState extends State<BuildTaskWidget> {
  bool showCompleted = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Pisahkan task berdasarkan status
    final completedTasks =
        widget.filteredTasks.where((task) => task.status).toList();
    final incompleteTasks =
        widget.filteredTasks.where((task) => !task.status).toList();

    // Kelompokkan incomplete task per matkul
    final Map<String, List<Task>> matkulGroups = {};
    for (var task in incompleteTasks) {
      final matkul = (task.matkul?.isNotEmpty == true) ? task.matkul! : "Umum";
      matkulGroups.putIfAbsent(matkul, () => []).add(task);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card untuk setiap matkul (incomplete)
          ...matkulGroups.entries.map(
            (entry) => Card(
              color: theme.colorScheme.surfaceContainer,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...entry.value
                        .map((task) => _buildTaskTile(context, task, false)),
                  ],
                ),
              ),
            ),
          ),

          // Card untuk completed
          Card(
            color: theme.colorScheme.surfaceContainer,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => setState(() => showCompleted = !showCompleted),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
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
                    if (showCompleted)
                      ...completedTasks
                          .map((task) => _buildTaskTile(context, task, true)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskTile(BuildContext context, Task task, bool completed) {
    return ListTile(
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
          (task.dateTime != null) ? Text(formatTaskDate(task.dateTime!)) : null,
      trailing: IconButton(
        onPressed: () {
          setState(() {
            task.isStared = !task.isStared;
          });
        },
        icon: task.isStared
            ? const Icon(Icons.star, color: Colors.amber)
            : const Icon(Icons.star_border),
      ),
    );
  }
}
