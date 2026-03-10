import 'package:date_time_format/date_time_format.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:jaku/modules/main_tab/bloc/main_tab_bloc.dart';
import 'package:jaku/modules/matkul/bloc/matkul_bloc.dart';
import 'package:jaku/modules/notification/bloc/notification_bloc.dart';
import 'package:jaku/modules/notification/bloc/notification_event.dart';
import 'package:jaku/modules/task/bloc/task_bloc.dart';
import 'package:jaku/modules/task/bloc/task_event.dart';
import 'package:jaku/modules/task/bloc/task_state.dart';
import 'package:jaku/data/entities/matkul.dart';
import 'package:jaku/data/entities/task.dart';
import 'package:jaku/data/entities/task_tab.dart';
import 'package:jaku/core/utils/snackbar_widget.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class DetailTaskModal extends HookWidget {
  const DetailTaskModal({super.key, required this.taskId});
  final String taskId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    TextEditingController titleController = useTextEditingController();
    TextEditingController descController = useTextEditingController();
    final selectedMatkulId = useState<String?>(null);
    final dueDate = useState<DateTime?>(null);
    final isStared = useState<bool>(false);
    final showDescField = useState<bool>(false);

    void initializeControllers(Task task) {
      titleController.text = task.task;
      descController.text = task.desc ?? '';
      selectedMatkulId.value = task.groupId;
      dueDate.value = task.taskDueDate;
      isStared.value = task.isStared;
      showDescField.value = task.desc != null && task.desc!.isNotEmpty;
    }

    void updateTask(Task task) {
      try {
        final updatedTask = task.copyWith(
          task: titleController.text,
          desc: descController.text,
          isStared: isStared.value,
          groupId: selectedMatkulId.value,
          taskDueDate: dueDate.value,
        );

        context.read<TaskBloc>().add(UpdateTask(updatedTask));

        if (dueDate.value != null && dueDate.value!.isAfter(DateTime.now())) {
          final matkulState = context.read<MatkulBloc>().state;
          final mainTabState = context.read<MainTabBloc>().state;
          List<Matkul> matkulList = matkulState.matkuls;
          final taskTabs = mainTabState.taskTabs;

          Matkul? matkul;
          TaskTab? taskTab;
          bool isCustomTab =
              selectedMatkulId.value != null &&
              selectedMatkulId.value!.startsWith("tab");
          if (selectedMatkulId.value != null) {
            if (isCustomTab) {
              taskTab = taskTabs
                  .where((t) => t.id == selectedMatkulId.value)
                  .firstOrNull;
            } else {
              matkul = matkulList
                  .where((m) => m.id == selectedMatkulId.value)
                  .firstOrNull;
            }
          }

          context.read<NotificationBloc>().add(
            ScheduleNotification(
              title: titleController.text,
              body: matkul == null
                  ? (taskTab != null
                        ? "${taskTab.tabName} Task"
                        : "General Task")
                  : "${matkul.name} Task",
              scheduledTime: dueDate.value!,
              notifId: task.id.hashCode,
              taskId: task.id,
            ),
          );
        }

        context.pop();
        showAppSnackbar(title: "Success!", message: "Berhasil mengubah task");
      } catch (error) {
        showAppSnackbar(
          title: "Error!",
          message: "Error: $error",
          isSuccess: false,
        );
      }
    }

    void deleteTask(Task task, ThemeData theme) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            "Hapus task?",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: theme.dialogTheme.backgroundColor,
          content: Text(
            "Yakin ingin menghapus task ${task.task}?",
            textAlign: TextAlign.center,
          ),
          actions: [
            FilledButton(
              onPressed: () => context.pop(),
              child: const Text("Tidak"),
            ),
            OutlinedButton(
              onPressed: () {
                context.pop(); // Close dialog
                context.pop(); // Close modal
                context.read<TaskBloc>().add(DeleteTask(task.id));
                context.read<NotificationBloc>().add(
                  CancelNotification(task.id.hashCode),
                );
                showAppSnackbar(
                  title: "Success!",
                  message: "Berhasil menghapus task",
                );
              },
              child: const Text("Ya"),
            ),
          ],
        ),
      );
    }

    useEffect(() {
      context.read<TaskBloc>().add(LoadTask(taskId));
      return null;
    }, [taskId]);

    return BlocConsumer<TaskBloc, TaskState>(
      listenWhen: (previous, current) {
        return current.selectedTask != null &&
            current.selectedTask!.id == taskId;
      },
      listener: (context, state) {
        initializeControllers(state.selectedTask!);
      },
      builder: (context, state) {
        final task = state.selectedTask;
        final isCorrectTask = task != null && task.id == taskId;

        if (!isCorrectTask && state.status == TaskStatus.loading) {
          return const SizedBox(
            height: 300,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (!isCorrectTask) {
          return const SizedBox(
            height: 300,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final matkulState = context.watch<MatkulBloc>().state;
        final mainTabState = context.watch<MainTabBloc>().state;

        List<Matkul> matkulList = matkulState.matkuls;
        final taskTabs = mainTabState.taskTabs;

        final timeNow = TimeOfDay.now();

        String showGroup() {
          try {
            if (selectedMatkulId.value == null ||
                selectedMatkulId.value == "") {
              return "Select group";
            } else {
              if (selectedMatkulId.value!.startsWith("tab")) {
                final tab = taskTabs
                    .where((t) => t.id == selectedMatkulId.value)
                    .firstOrNull;
                return tab?.tabName ?? "Unknown Tab";
              } else {
                final matkul = matkulList
                    .where((m) => m.id == selectedMatkulId.value)
                    .firstOrNull;
                return matkul?.nameAbbreviation ?? "Unknown Matkul";
              }
            }
          } catch (e) {
            return "Error showing group";
          }
        }

        return SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                right: 20,
                left: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 5,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          customButton: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 3,
                              horizontal: 6,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              spacing: 6,
                              children: [
                                Text(showGroup()),
                                if (selectedMatkulId.value != null &&
                                    selectedMatkulId.value != "")
                                  IconButton(
                                    onPressed: () {
                                      selectedMatkulId.value = null;
                                    },
                                    icon: const Icon(LucideIcons.x, size: 16),
                                    constraints: const BoxConstraints(),
                                    padding: EdgeInsets.zero,
                                  ),
                                const Icon(LucideIcons.chevronDown),
                              ],
                            ),
                          ),
                          buttonStyleData: ButtonStyleData(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          items: [
                            ...matkulList.map(
                              (item) => DropdownItem<String>(
                                value: item.id,
                                child: Text(item.nameAbbreviation),
                              ),
                            ),
                            ...taskTabs.map(
                              (item) => DropdownItem<String>(
                                value: item.id,
                                child: Text(item.tabName),
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            selectedMatkulId.value = value;
                          },
                          alignment: AlignmentDirectional.centerStart,
                          dropdownStyleData: DropdownStyleData(
                            width: 200,
                            maxHeight: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => deleteTask(task, theme),
                        icon: const Icon(LucideIcons.trash2),
                      ),
                    ],
                  ),
                  TextField(
                    controller: titleController,
                    style: theme.textTheme.titleLarge,
                    decoration: const InputDecoration(
                      hintText: 'Task',
                      border: InputBorder.none,
                      filled: false,
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                  if (showDescField.value || descController.text.isNotEmpty)
                    TextField(
                      controller: descController,
                      minLines: 1,
                      maxLines: null,
                      style: theme.textTheme.titleMedium,
                      decoration: const InputDecoration(
                        hintText: 'Details',
                        border: InputBorder.none,
                        filled: false,
                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  if (dueDate.value != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Chip(
                        label: Text(
                          DateTimeFormat.format(
                            dueDate.value!,
                            format:
                                (dueDate.value!.hour == 0 &&
                                    dueDate.value!.minute == 0)
                                ? "d F Y"
                                : "d F Y, H:i",
                          ),
                          style: theme.textTheme.bodySmall,
                        ),
                        onDeleted: () {
                          dueDate.value = null;
                        },
                      ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              showDescField.value = true;
                            },
                            icon: const Icon(LucideIcons.textAlignStart),
                          ),
                          IconButton(
                            onPressed: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: dueDate.value ?? DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (date != null) {
                                if (dueDate.value != null) {
                                  dueDate.value = DateTime(
                                    date.year,
                                    date.month,
                                    date.day,
                                    dueDate.value!.hour,
                                    dueDate.value!.minute,
                                  );
                                } else {
                                  dueDate.value = date;
                                }
                              }
                            },
                            icon: const Icon(LucideIcons.calendar),
                          ),
                          IconButton(
                            onPressed: () async {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay(
                                  hour: dueDate.value?.hour ?? timeNow.hour,
                                  minute:
                                      dueDate.value?.minute ?? timeNow.minute,
                                ),
                              );
                              if (time != null) {
                                final date = dueDate.value ?? DateTime.now();
                                dueDate.value = DateTime(
                                  date.year,
                                  date.month,
                                  date.day,
                                  time.hour,
                                  time.minute,
                                );
                              }
                            },
                            icon: const Icon(LucideIcons.clock),
                          ),
                          IconButton(
                            onPressed: () {
                              isStared.value = !isStared.value;
                            },
                            icon: Icon(
                              isStared.value ? Icons.star : Icons.star_border,
                              color: isStared.value ? Colors.amberAccent : null,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () => updateTask(task),
                        child: const Text("Save"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
