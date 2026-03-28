import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:jaku/core/utils/my_snackbar.dart';
import 'package:jaku/modules/main_tab/bloc/main_tab_bloc.dart';
import 'package:jaku/modules/main_tab/bloc/main_tab_state.dart';
import 'package:jaku/modules/matkul/bloc/matkul_bloc.dart';
import 'package:jaku/modules/matkul/bloc/matkul_state.dart';
import 'package:jaku/modules/notification/bloc/notification_bloc.dart';
import 'package:jaku/modules/notification/bloc/notification_event.dart';
import 'package:jaku/modules/task/bloc/task_bloc.dart';
import 'package:jaku/modules/task/bloc/task_event.dart';
import 'package:jaku/data/entities/matkul.dart';
import 'package:jaku/data/entities/task.dart';
import 'package:jaku/data/entities/task_tab.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:uuid/uuid.dart';

class AddTaskModal extends HookWidget {
  const AddTaskModal({super.key, this.matkulId, this.starred = false});
  final String? matkulId;
  final bool starred;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final TextEditingController titleController = useTextEditingController();
    final TextEditingController descController = useTextEditingController();

    final selectedMatkulId = useState<String?>(null);
    final dueDate = useState<DateTime?>(null);
    final isStared = useState<bool>(false);
    final showDescField = useState<bool>(false);

    useEffect(() {
      if (matkulId != null) {
        selectedMatkulId.value = matkulId;
      }
      return null;
    }, [matkulId]);

    useValueListenable(titleController);
    useValueListenable(descController);

    void addTask() {
      try {
        final id = const Uuid().v4();
        final newTask = Task(
          id: id,
          task: titleController.text,
          status: false,
          isStared: isStared.value,
          desc: descController.text,
          groupId: selectedMatkulId.value,
          taskDueDate: dueDate.value,
        );

        context.read<TaskBloc>().add(AddTask(newTask));

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
              notifId: id.hashCode,
              taskId: id,
            ),
          );
        }

        context.pop();
        MySnackbar.success(
          title: "Success!",
          message: "Berhasil menambahkan task",
        );
      } catch (error) {
        MySnackbar.error(title: "Error!", message: "Error: $error");
      }
    }

    return BlocBuilder<MatkulBloc, MatkulState>(
      builder: (context, matkulState) {
        return BlocBuilder<MainTabBloc, MainTabState>(
          builder: (context, mainTabState) {
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
                          dropdownSeparator: const DropdownSeparator(
                            height: 4,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Divider(),
                            ),
                          ),
                          items: [
                            ...matkulList.map(
                              (item) => DropdownItem<String>(
                                value: item.id,
                                child: Text(item.name),
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
                              dueDate.value!.hour == 0 &&
                                      dueDate.value!.minute == 0
                                  ? "${dueDate.value!.day}/${dueDate.value!.month}/${dueDate.value!.year}"
                                  : "${dueDate.value!.day}/${dueDate.value!.month}/${dueDate.value!.year} ${dueDate.value!.hour.toString().padLeft(2, '0')}:${dueDate.value!.minute.toString().padLeft(2, '0')}",
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
                                    initialDate:
                                        dueDate.value ?? DateTime.now(),
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
                                          dueDate.value?.minute ??
                                          timeNow.minute,
                                    ),
                                  );
                                  if (time != null) {
                                    final date =
                                        dueDate.value ?? DateTime.now();
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
                                  isStared.value
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: isStared.value
                                      ? Colors.amberAccent
                                      : null,
                                ),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: titleController.text.trim().isNotEmpty
                                ? () => addTask()
                                : null,
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
      },
    );
  }
}
