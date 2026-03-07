import 'package:date_time_format/date_time_format.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:jaku/modules/main_tab/bloc/main_tab_bloc.dart';
import 'package:jaku/modules/matkul/bloc/matkul_bloc.dart';
import 'package:jaku/modules/matkul/bloc/matkul_event.dart';
import 'package:jaku/modules/matkul/bloc/matkul_state.dart';
import 'package:jaku/modules/notification/bloc/notification_bloc.dart';
import 'package:jaku/modules/notification/bloc/notification_event.dart';
import 'package:jaku/modules/task/bloc/task_bloc.dart';
import 'package:jaku/modules/task/bloc/task_event.dart';
import 'package:jaku/modules/task/bloc/task_state.dart';
import 'package:jaku/data/entities/matkul.dart';
import 'package:jaku/data/entities/task_tab.dart';
import 'package:jaku/core/utils/snackbar_widget.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class DetailTaskModal extends HookWidget {
  const DetailTaskModal({super.key, required this.taskId});
  final String taskId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final taskBloc = context.read<TaskBloc>();

    final state = context.watch<TaskBloc>().state;
    
    useEffect(() {
      taskBloc.add(LoadTask(taskId));
      return null;
    }, [taskId]);

    final task = state.selectedTask;
    if (task == null && state.status == TaskStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (task == null) {
      // If still null after loading, maybe it was deleted or error
      if (state.status == TaskStatus.success || state.status == TaskStatus.error) {
         WidgetsBinding.instance.addPostFrameCallback((_) => context.pop());
      }
      return const SizedBox.shrink();
    }

    final titleController = useTextEditingController(text: task.task);
    final descController = useTextEditingController(text: task.desc);
    final selectedMatkulId = useState<String?>(task.groupId);
    final dueDate = useState<DateTime?>(task.taskDueDate);
    final isStared = useState<bool>(task.isStared);
    final showDescField = useState<bool>(task.desc != null && task.desc!.isNotEmpty);

    final matkulState = context.watch<MatkulBloc>().state;
    final mainTabState = context.watch<MainTabBloc>().state;

    List<Matkul> matkulList = matkulState.matkuls;
    final taskTabs = mainTabState.taskTabs;

    String showGroup() {
      try {
        if (selectedMatkulId.value == null || selectedMatkulId.value == "") {
          return "Select group";
        } else {
          if (selectedMatkulId.value!.startsWith("tab")) {
            final tab = taskTabs.where((t) => t.id == selectedMatkulId.value).firstOrNull;
            return tab?.tabName ?? "Unknown Tab";
          } else {
            final matkul = matkulList.where((m) => m.id == selectedMatkulId.value).firstOrNull;
            return matkul?.nameAbbreviation ?? "Unknown Matkul";
          }
        }
      } catch (e) {
        return "Error showing group";
      }
    }

    void updateTask() {
      try {
        final updatedTask = task.copyWith(
          task: titleController.text,
          desc: descController.text,
          isStared: isStared.value,
          groupId: selectedMatkulId.value,
          taskDueDate: dueDate.value,
        );

        taskBloc.add(UpdateTask(updatedTask));

        if (dueDate.value != null && dueDate.value!.isAfter(DateTime.now())) {
          Matkul? matkul;
          TaskTab? taskTab;
          bool isCustomTab = selectedMatkulId.value != null && selectedMatkulId.value!.startsWith("tab");
          if (selectedMatkulId.value != null) {
            if (isCustomTab) {
              taskTab = taskTabs.where((t) => t.id == selectedMatkulId.value).firstOrNull;
            } else {
              matkul = matkulList.where((m) => m.id == selectedMatkulId.value).firstOrNull;
            }
          }

          context.read<NotificationBloc>().add(ScheduleNotification(
            title: titleController.text,
            body: matkul == null
                ? (taskTab != null ? "${taskTab.tabName} Task" : "General Task")
                : "${matkul.name} Task",
            scheduledTime: dueDate.value!,
            notifId: task.id.hashCode,
            taskId: task.id,
          ));
        }

        context.pop();
        showAppSnackbar(title: "Success!", message: "Berhasil mengubah task");
      } catch (error) {
        showAppSnackbar(title: "Error!", message: "Error: $error", isSuccess: false);
      }
    }

    void deleteTask() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Hapus task?", style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: theme.dialogTheme.backgroundColor,
          content: Text("Yakin ingin menghapus task ${task.task}?", textAlign: TextAlign.center),
          actions: [
            FilledButton(onPressed: () => context.pop(), child: const Text("Tidak")),
            OutlinedButton(
              onPressed: () {
                context.pop(); // Close dialog
                context.pop(); // Close modal
                taskBloc.add(DeleteTask(task.id));
                context.read<NotificationBloc>().add(CancelNotification(task.id.hashCode));
                showAppSnackbar(title: "Success!", message: "Berhasil menghapus task");
              },
              child: const Text("Ya"),
            ),
          ],
        ),
      );
    }

    return SafeArea(
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
                      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                      child: Row(
                        mainAxisSize: Map<String, dynamic>.from({}).isEmpty ? MainAxisSize.min : MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 6,
                        children: [
                          Text(showGroup()),
                          if (selectedMatkulId.value != null && selectedMatkulId.value != "")
                            IconButton(
                              onPressed: () => selectedMatkulId.value = null,
                              icon: const Icon(LucideIcons.x, size: 16),
                              constraints: const BoxConstraints(),
                              padding: EdgeInsets.zero,
                            ),
                          const Icon(LucideIcons.chevronDown),
                        ],
                      ),
                    ),
                    buttonStyleData: ButtonStyleData(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                    ),
                    items: [
                      ...matkulList.map((item) => DropdownItem<String>(
                        value: item.id,
                        child: Text(item.nameAbbreviation),
                      )),
                      ...taskTabs.map((item) => DropdownItem<String>(
                        value: item.id,
                        child: Text(item.tabName),
                      )),
                    ],
                    onChanged: (value) => selectedMatkulId.value = value,
                    alignment: AlignmentDirectional.centerStart,
                    dropdownStyleData: DropdownStyleData(
                      width: 200,
                      maxHeight: 200,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                IconButton(onPressed: deleteTask, icon: const Icon(LucideIcons.trash2)),
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
                    DateTimeFormat.format(dueDate.value!, format: (dueDate.value!.hour == 0 && dueDate.value!.minute == 0) ? "d F Y" : "d F Y, H:i"),
                    style: theme.textTheme.bodySmall,
                  ),
                  onDeleted: () => dueDate.value = null,
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(onPressed: () => showDescField.value = true, icon: const Icon(LucideIcons.textAlignStart)),
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
                            dueDate.value = DateTime(date.year, date.month, date.day, dueDate.value!.hour, dueDate.value!.minute);
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
                            hour: dueDate.value?.hour ?? 0,
                            minute: dueDate.value?.minute ?? 0,
                          ),
                        );
                        if (time != null) {
                          final date = dueDate.value ?? DateTime.now();
                          dueDate.value = DateTime(date.year, date.month, date.day, time.hour, time.minute);
                        }
                      },
                      icon: const Icon(LucideIcons.clock),
                    ),
                    IconButton(
                      onPressed: () => isStared.value = !isStared.value,
                      icon: Icon(isStared.value ? Icons.star : Icons.star_border, color: isStared.value ? Colors.amberAccent : null),
                    ),
                  ],
                ),
                TextButton(onPressed: updateTask, child: const Text("Save")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
