import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaku/controllers/main_tab_controller.dart';
import 'package:jaku/controllers/matkul_controllers.dart';
import 'package:jaku/controllers/task_controllers/task_controller.dart';
import 'package:jaku/models/matkul.dart';
import 'package:jaku/utils/snackbar_widget.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AddTaskModal extends StatefulWidget {
  const AddTaskModal({super.key, this.matkulId, this.starred = false});
  final String? matkulId;
  final bool starred;

  @override
  State<AddTaskModal> createState() => _AddTaskModalState();
}

class _AddTaskModalState extends State<AddTaskModal> {
  final taskC = Get.find<TaskController>();
  final matkulC = Get.find<MatkulController>();
  final tabC = Get.find<MainTabController>();
  late List<Matkul> matkulList;

  bool showDescField = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //init controller
    taskC.matkulIdC.value = widget.matkulId;

    matkulList = matkulC.allMatkul;
    print("starred value: ${widget.starred}");
    if (widget.starred) {
      taskC.isStaredC.value = true;
    }
  }

  @override
  void dispose() {
    taskC.titleC.clear();
    taskC.descC.clear();
    taskC.isStaredC.value = false;
    taskC.dueDateC.value = null;
    taskC.matkulIdC.value = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    String showGroup() {
      try {
        if (taskC.matkulIdC.value == null || taskC.matkulIdC.value == "") {
          return "Select group";
        } else {
          if (taskC.matkulIdC.value!.startsWith("tab")) {
            return tabC.selectTabById(taskC.matkulIdC.value!)!.tabName;
          } else {
            return matkulC
                .selectMatkulById(taskC.matkulIdC.value!)!
                .abbreviation;
          }
        }
      } catch (e) {
        return "Error showing group";
      }
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
            DropdownButtonHideUnderline(
              child: Obx(
                () => DropdownButton2(
                  customButton: Container(
                    padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 6,
                      children: [
                        Text(showGroup()),
                        taskC.matkulIdC.value == null ||
                                taskC.matkulIdC.value == ""
                            ? const SizedBox.shrink()
                            : IconButton(
                                onPressed: () {
                                  taskC.matkulIdC.value = null;
                                },
                                icon: const Icon(LucideIcons.x),
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
                  value: taskC.matkulIdC.value,

                  items: [
                    ...matkulList.map(
                      (item) => DropdownMenuItem<Object>(
                        value: item.id,
                        child: Text(item.abbreviation),
                      ),
                    ),
                    ...tabC.taskTabs.map(
                      (item) => DropdownMenuItem<Object>(
                        value: item.id,
                        child: Text(item.tabName),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    taskC.matkulIdC.value = value as String?;
                    print("selected matkul: ${taskC.matkulIdC.value}");
                  },
                  alignment: AlignmentDirectional.centerStart,
                  dropdownStyleData: DropdownStyleData(
                    width: 200,
                    maxHeight: 200,
                    direction: DropdownDirection.textDirection,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
            TextField(
              controller: taskC.titleC,
              style: theme.textTheme.titleLarge,
              decoration: const InputDecoration(
                hintText: 'Task',
                border: InputBorder.none,
                filled: false,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
              ),
            ),
            if (showDescField)
              TextField(
                controller: taskC.descC,
                minLines: 1,
                maxLines: null, // expands vertically when overflow
                style: theme.textTheme.titleMedium,
                decoration: const InputDecoration(
                  hintText: 'Details',
                  border: InputBorder.none,
                  filled: false,
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            Obx(
              () => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (taskC.dueDateC.value != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: Chip(
                        label: Text(
                          // Tampilkan tanggal dan jam jika ada
                          taskC.dueDateC.value!.hour == 0 &&
                                  taskC.dueDateC.value!.minute == 0
                              ? "${taskC.dueDateC.value!.day}/${taskC.dueDateC.value!.month}/${taskC.dueDateC.value!.year}"
                              : "${taskC.dueDateC.value!.day}/${taskC.dueDateC.value!.month}/${taskC.dueDateC.value!.year} ${taskC.dueDateC.value!.hour.toString().padLeft(2, '0')}:${taskC.dueDateC.value!.minute.toString().padLeft(2, '0')}",
                          style: theme.textTheme.bodySmall,
                        ),
                        onDeleted: () {
                          taskC.dueDateC.value = null;
                        },
                      ),
                    ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Obx(
                  () => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            showDescField = true;
                          });
                        },
                        icon: const Icon(LucideIcons.alignLeft),
                      ),
                      IconButton(
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: taskC.dueDateC.value ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (date != null) {
                            // Jika sebelumnya sudah ada jam, pertahankan jam
                            if (taskC.dueDateC.value != null) {
                              final old = taskC.dueDateC.value!;
                              taskC.dueDateC.value = DateTime(
                                date.year,
                                date.month,
                                date.day,
                                old.hour,
                                old.minute,
                              );
                            } else {
                              taskC.dueDateC.value = date;
                            }
                          }
                        },
                        icon: const Icon(LucideIcons.calendar),
                      ),
                      if (taskC.dueDateC.value != null)
                        IconButton(
                          onPressed: () async {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay(
                                hour: taskC.dueDateC.value!.hour,
                                minute: taskC.dueDateC.value!.minute,
                              ),
                            );
                            if (time != null) {
                              final date = taskC.dueDateC.value!;
                              taskC.dueDateC.value = DateTime(
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
                          taskC.isStaredC.value = !taskC.isStaredC.value;
                        },
                        icon: taskC.isStaredC.value
                            ? const Icon(Icons.star, color: Colors.amberAccent)
                            : const Icon(Icons.star_border),
                      ),
                    ],
                  ),
                ),

                TextButton(
                  onPressed: taskC.titleC.text.trim().isEmpty
                      ? null // tombol disable
                      : () {
                          try {
                            taskC.addTask();
                            Get.back();
                            showAppSnackbar(
                              title: "Sucess!",
                              message: "Berhasil menambahkan task",
                            );
                          } catch (error) {
                            showAppSnackbar(
                              title: "Error!",
                              message: "Error: $error",
                            );
                          }
                        },
                  child: const Text("Save"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
